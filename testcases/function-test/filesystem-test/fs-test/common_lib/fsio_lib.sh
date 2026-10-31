#!/usr/bin/bash
# Copyright (c) [2022] Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
# @Author        :   @meitingli
# @Contact       :   244349477@qq.com
# @Date          :   2020-10-15
# @License       :   Mulan PSL v2
# @Desc          :   Public function
#####################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh
# 统一选盘/系统盘防护（get_system_disk / get_root_disk / check_free_disk）。
# 本套件原先用 `fdisk -l | ... | awk 'NR==2'` 裸选盘，既不保证选到空闲盘，
# 也不排除系统盘，在只有一块盘的机器上会直接对系统盘做 pvcreate。
source "${OET_PATH}/libs/locallibs/disk_select_lib.sh"
export FS_TYPE="ext3 ext4 xfs"
export LANG=en_US.UTF-8
# 只在 lvm 工具确实缺失时才安装。本文件在每个用例 source 时都会执行到这里，
# 无条件 DNF_INSTALL 会把 lvm2 及其全部依赖反复写进 $tmpfile，
# post_test 的 DNF_REMOVE 再把这些依赖整批判掉，极易误删系统基础包。
if ! command -v vgcreate >/dev/null 2>&1; then
    DNF_INSTALL lvm2
fi

function CREATE_LV() {
    lvname=$1
    vggroup=$2
    lvcreate -n "$lvname" -L 0.5G "$vggroup" -y
}

function EXTEND_LV() {
    lvname=$1
    lvextend -L 3G "$lvname" -y
}

function REDUCE_LV() {
    lvname=$1
    lvreduce -L 0.1G "$lvname" -y
}

function CHANGE_LV() {
    vggroup=$1
    lvchange -p rw "$lvname" -y
}

function DELETE_LV() {
    lvname=$1
    lvremove "$lvname" -y
}

function CONCURRENCY_THREAD() {
    # $1: execution cmd
    # $2: execution time, default is 100
    start_time=$(date +%s)
    command=$1
    concurrency_num=${2-"100"}

    # Create fifo and exec
    [ -e /tmp/fd1 ] || mkfifo /tmp/fd1
    exec 3<>/tmp/fd1
    rm -rf /tmp/fd1
    for ((i = 0; i < 9; i++)); do
        echo ""
    done >&3
    count=1
    for j in $(seq 0 "$concurrency_num"); do
        read -r -u3
        {
            $command $count
            sleep 5
            echo "" >&3
        } &
        count=$((count + 1))
    done
    wait
    end_time=$(date +%s)
    exec_time=$((end_time - start_time))
    echo "Exectue $concurrency_num cmd for times: ""$exec_time"
    exec 3>&-
    exec 3<&-
}

function GET_CONSOLE() {
    # 原来写死了 aarch64 的 edk2 固件与 x86_64 的 kvm 加速，在 riscv64 上必然失败。
    # 仅在明确需要控制台的场景下由用例改写；这里给出可用的默认实现：
    # 有 qemu-system-$(uname -m) 就用当前架构，否则直接报错返回，不再让用例卡住。
    local _qemu
    _qemu="qemu-system-$(uname -m)"
    if ! command -v "$_qemu" >/dev/null 2>&1; then
        LOG_ERROR "GET_CONSOLE: $_qemu not available on $(uname -m), cannot start a console VM."
        return 1
    fi
    "$_qemu" -m 4096 -smp 4 -nographic -serial file:testlog \
        -drive file=/data/images/XX.qcow2,format=qcow2,if=virtio
}

function CREATE_VG() {
    cur_date=$(date +%Y%m%d%H%M%S)
    # 原实现用 `fdisk -l | ... | awk 'NR==2'` 按位置裸选盘：既可能选中系统盘，
    # 也可能在没有第二块盘时返回空串，让 pvcreate 退化成对空设备/目录操作。
    # 改为走统一选盘，且明确拒绝系统盘。
    local _disk
    _disk=$(TEST_DISK 1 2>/dev/null | awk '{print $1}')
    if [ -z "${_disk}" ] || [ ! -b "/dev/${_disk}" ]; then
        __abort_test_disk "no usable free test disk found (got '${_disk}'), abort to protect the OS."
    fi
    local _system_disks
    _system_disks=$(get_system_disk 2>/dev/null)
    case " ${_system_disks} " in
        *" ${_disk} "*)
            __abort_test_disk "refuse to use system disk [${_disk}] for volume group, abort to protect the OS."
            ;;
    esac
    disk_name="/dev/${_disk}"
    if pvcreate "$disk_name" -f &>/dev/null; then
        vggroup="test_vggroup$cur_date"
        vgcreate "$vggroup" "$disk_name" >/dev/null
    else
        vggroup=$(pvcreate "$disk_name" 2>&1 | grep "test_vggroup" | cut -d '"' -f 4)
    fi
    printf "%s" "$vggroup"
}

function CREATE_FS() {
    fs_type="${1:-$FS_TYPE}"
    cur_date=$(date +%Y%m%d%H%M%S)
    vggroup=$(CREATE_VG)
    count=1
    msg=$vggroup" "
    for fs in $fs_type; do
        lvname="test_lv"$count$cur_date
        point="/tmp/point"$count$cur_date
        lvcreate -n "$lvname" -L 512M "$vggroup" -y >/dev/null
        mkfs -t "$fs" /dev/"$vggroup"/"$lvname" >/dev/null
        mkdir "$point"
        mount /dev/"$vggroup"/"$lvname" "$point" >/dev/null
        msg=$msg$point" "
        count=$((count + 1))
    done
    echo "$msg"
}

function REMOVE_FS() {
    point_list=("$1")
    for i in $(seq 0 $((${#point_list[@]} - 1))); do
        tmp=${point_list[$i]}
        [ -n "$tmp" ] || continue
        # 原来只用 `df -T | grep` 找设备，匹配不到就 continue 静默跳过，
        # 于是挂载点残留、LV 残留，后续用例再挂载时出现 "target is busy" 或
        # "already mounted"，把真实问题掩盖成随机失败。
        # 这里补一条 /proc/mounts 兜底，并把残留情况记日志。
        lv=$(df -T 2>/dev/null | awk -v p="$tmp" '$NF == p {print $1; exit}')
        if [[ -z "$lv" ]]; then
            lv=$(awk -v p="$tmp" '$2 == p {print $1; exit}' /proc/mounts 2>/dev/null)
        fi
        if [[ -z "$lv" ]]; then
            LOG_WARN "REMOVE_FS: $tmp is not mounted, skip unmount."
        else
            umount -f "$tmp" >/dev/null 2>&1 || umount -l "$tmp" >/dev/null 2>&1
            [[ -n "$(findmnt -no SOURCE --target "$tmp" 2>/dev/null)" ]] && \
                LOG_WARN "REMOVE_FS: failed to unmount $tmp (device $lv)."
        fi
        [ -d "$tmp" ] && rm -rf "$tmp"
        if [[ -n "$lv" ]] && [[ "$lv" == /dev/* ]]; then
            DELETE_LV "$lv"
        fi
    done
}

function REMOVE_VG() {
    # 原来这里也做了一次 DNF_INSTALL lvm2，把安装副作用带进清理阶段。
    # 清理函数只应卸载卷组，不应再改软件包状态。
    if ! command -v vgremove >/dev/null 2>&1; then
        LOG_WARN "REMOVE_VG: lvm2 tools not available, skip volume group cleanup."
        return 0
    fi
    vggroup=$1
    [[ "$vggroup" != "" ]] && {
        vgremove "$vggroup" -y
    }
    mounted=$(df -T | grep "test_vggroup" | awk '{print $7}')
    if [[ "$mounted" != "" ]]; then
        for m in $mounted; do
            umount "$m"
        done
        vggroup=$(df -T | grep "test_vggroup" | awk '{print $1}' | cut -d '-' -f 1 | cut -d '/' -f 4 | head -n 1)
        vgremove "$vggroup" -y
    fi

    if lsblk | grep -q "test_vggroup"; then
        vggroup=$(lsblk | grep "test_vggroup" | awk '{print $1}' | head -n 1 | cut -d '-' -f 1)
        vggroup=${vggroup:2}
        vgremove "$vggroup" -y
    fi
    rm -rf /tmp/point*
}

function GET_RANDOMNAME() {
    exp_len=$1
    j=0
    name=""
    for i in {a..z}; do
        ranList[$j]=$i
        j=$((j + 1))
    done
    for i in {A..Z}; do
        ranList[$j]=$i
        j=$((j + 1))
    done
    for i in {0..9}; do
        ranList[$j]=$i
        j=$((j + 1))
    done

    for i in $(seq 1 "$exp_len"); do
        index=$((RANDOM % j))
        name=$name${ranList[$index]}
    done
    printf "%s" "$name"
}

function CREATE_LARGE_FILE() {
    dir=$1
    max_path_len=$(getconf PATH_MAX "$dir")

    for i in $(seq 1 100); do
        text=$(GET_RANDOMNAME "$max_path_len")
        echo "$text" >>"$dir"/testFile
    done
}

function SET_BKG_MONITOR() {
    tmp_point=$1
    top -d 2 >"$tmp_point"/cpu.log &
    iostat -d 2 >"$tmp_point"/iostat.log &
}

function CHECK_BKG_MONITOR() {
    tmp_point=$1
    cpu_line=$2
    io_line=$3
    free_disk=$(TEST_DISK 1 2>/dev/null | awk '{print $1}')
    [ -z "$free_disk" ] && free_disk=$(lsblk -rno NAME,TYPE 2>/dev/null | awk '$2 == "disk" {print $1}' | tail -n 1)
    top_pid=$(pgrep -f "top -d 2" | head -n 1)
    iostat_pid=$(pgrep -f "iostat -d 2" | head -n 1)
    kill -9 "$top_pid" "$iostat_pid"
    free_cpu=$(grep "Cpu" cpu.log | awk '{print $8}')
    read_io=$(grep "$free_disk" iostat.log | awk '{print $3}')
    wrtn_io=$(grep "$free_disk" iostat.log | awk '{print $4}')
    for var in "${free_cpu[@]}"; do
        [[ $var -lt $cpu_line ]] && {
            return 1
        }
    done
    for var in "${read_io[@]}"; do
        [[ $var -gt $io_line ]] && {
            return 1
        }
    done
    for var in "${wrtn_io[@]}"; do
        [[ $var -gt $io_line ]] && {
            return 1
        }
    done

    return 0
}

function ssh_cmd_node() {
    cmd=$1
    SSH_CMD "$cmd" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
}

# 本文件被每个用例 source 时都会执行到这里。原先是无条件 `REMOVE_VG "$@"`，
# 而 mugen 会给用例脚本传 -x 之类的参数，于是卷组名被当成 "-x"，
# 清理逻辑在用例还没开始时就去动磁盘。改为：
#   - 只有在确实残留 test_vggroup 时才清理；
#   - 参数只接受合法卷组名，其余全部忽略。
if command -v vgs >/dev/null 2>&1 &&
    vgs --noheadings -o vg_name 2>/dev/null | grep -qw "test_vggroup.*"; then
    __leftover_vg=""
    for __a in "$@"; do
        case "$__a" in
            -* | "") ;;
            test_vggroup*) __leftover_vg="$__a" ;;
        esac
    done
    unset __a
    if [ -z "${__leftover_vg}" ]; then
        __leftover_vg=$(vgs --noheadings -o vg_name 2>/dev/null |
            grep -o "test_vggroup[^ ]*" | head -n 1)
    fi
    if [ -n "${__leftover_vg}" ]; then
        LOG_WARN "leftover test volume group [${__leftover_vg}] found, cleaning up before the case starts."
        REMOVE_VG "$__leftover_vg"
    fi
    unset __leftover_vg
fi
