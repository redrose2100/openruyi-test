#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   fanlirong
#@Contact   	:   fanlirong1@h-partners.com
#@Date      	:   2025-12-04
#@License   	:   Mulan PSL v2
#@Desc      	:   Public function
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

test_qemu_dir="/home/test_qemu"
config_dir="${test_qemu_dir}/config"
image_dir="${test_qemu_dir}/image"
image_path="${image_dir}/openEuler.qcow2"
repo_baseurl=$(awk -F= '/baseurl/ {print $2; exit}' /etc/yum.repos.d/openEuler.repo | sed "s|/OS/\$basearch/||")
version=$(basename "${repo_baseurl}")
image_path_base="${image_dir}/${version}-aarch64.qcow2"
image_download_url="${repo_baseurl}/virtual_machine_img/aarch64/${version}-aarch64.qcow2.xz"

vm_ip="192.168.1.101"
vm_user="root"
vm_passwd="openEuler12#$"

QUOTA_STR=""
BACKUP_DIR="/tmp/QEMU_tmp"
MEMLINKD_CONFIG="/etc/memlinkd.conf"

function vm_clean() {
    virsh list --all --name | xargs -I {} virsh destroy {}
    virsh list --all --name | xargs -I {} virsh undefine {} --nvram
}

function pre_init() {
    if [ "$(arch)" != "aarch64" ];then
	echo "memlinkd仅支持ARM架构，非ARM架构跳过测试"
	exit 255
    fi
    # pkg pre
    chmod +x "${OET_PATH}/testcases/smoke-test/smoke-memlink/common/pkg_pre.sh"
    sh "${OET_PATH}/testcases/smoke-test/smoke-memlink/common/pkg_pre.sh"
    # img pre
    mkdir -p "$image_dir"
    SSH_CMD "mkdir -p $image_dir" "$NODE2_IPV4" "$NODE2_PASSWORD" "$NODE2_USER"
    if [ ! -f "$image_path" ]; then
        if [ -f "$image_path_base" ]; then
            cp "$image_path_base" "$image_path"
        else
            curl -kL -o "$image_path".xz "$image_download_url" --fail --connect-timeout 30
            unxz "$image_path".xz
        fi
    fi
    # xml pre
    mkdir -p "$config_dir"
    cp -arvf ../config "$test_qemu_dir"
    mkdir -p "$BACKUP_DIR"
    # net pre
    systemctl disable firewalld
    sysctl -w kernel.numa_balancing=0
    echo 1 > /proc/sys/net/ipv4/ip_forward
    iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -j MASQUERADE
    iptables -A FORWARD -i QEMU_br0 -j ACCEPT
    iptables -A FORWARD -o QEMU_br0 -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -L FORWARD -v -n
    brctl addbr br0
    ifconfig br0 192.168.1.99/24 up
    # config
    sysctl kernel.softlockup_panic | grep 0 || {
        sysctl kernel.softlockup_panic=0
        sysctl -p
    }
    setenforce 0
    # vm clean
    vm_clean
    rm -rf /var/log/libvirt/libvirtd.log*; rm -rf /var/log/libvirt/qemu/*
}

function backup_cfg() {
    for file in "$@"; do
        cp -arvf "${file}" "${BACKUP_DIR}" && LOG_ERROR "${file} backup success!"
    done
}

function recover_cfg() {
    for file in "$@"; do
        mv "${BACKUP_DIR}/$(basename "$file")" "${file}" && LOG_ERROR "${file} recover success!"
    done
}

function memlink_init() {
    command -v numactl || yum install -y numactl
    rpm -q memlinkd || yum install -y memlinkd
    systemctl is-active --quiet memlinkd || systemctl restart memlinkd
    backup_cfg "${MEMLINKD_CONFIG}"
}

function set_huge_mem() {
    local huge_size=$1
    local huge_2M="/sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages"
    echo 3 > /proc/sys/vm/drop_caches
    echo "$huge_size" > "$huge_2M"
    SLEEP_WAIT 10
    output=$(grep HugePages_ /proc/meminfo)
    total_local=$(echo "$output" | grep "HugePages_Total:" | sed 's/\r//' | awk '{print int($2)}')
    [ "$total_local" -ge "$huge_size" ] || LOG_WARN "set hugepage failed"
}

function change_cfgs() {
    local cfg_file=$1
    for option_value in "$@"; do
        [ "${option_value}" = "$1" ] && continue
        option=${option_value%%=*}
        value=${option_value#*=}
        sed -i "/^${option}=/ s/=.*/=${QUOTA_STR}${value}${QUOTA_STR}/" "$cfg_file" || LOG_ERROR "change_cfgs: [$cfg_file] $option_value mod failed"
    done
    diff --color "${cfg_file}" "${BACKUP_DIR}/$(basename "$cfg_file")"
}

function wait_exec() {
    local wait_cmd=$1
    local wait_count=${2:-30}
    for ((i = 1; i <= wait_count; i++)); do
        LOG_INFO "[$i] wait in cmd: ${wait_cmd}..."
        eval "${wait_cmd}" &> /dev/null && return 0
        SLEEP_WAIT 5
    done
    LOG_WARN "${wait_cmd} timeout failed"
    return 1
}

function create_vm_waiting_running() {
    local vm_name=$1
    local qcow2_path="${2:-${image_path}}"
    xml_path="${config_dir}/$vm_name.xml"
    [ ! -f "$xml_path" ] && {
        LOG_ERROR "$xml_path does not exist"
        exit 1
    }
    sed -i "s|IMAGE_PATH|${qcow2_path}|g" "${xml_path}"
    LOG_INFO "vm xml save dir: $xml_path; image dir is: $qcow2_path"
    virsh create "$xml_path" || return 1
    SLEEP_WAIT 120
    virsh list | grep -iq "$vm_name"
    return $?
}

function vm_sshx() {
    local cmd=$1
    local vm_ip="${2:-${vm_ip}}"
    SSH_CMD "$cmd" "$vm_ip" "$vm_passwd" "$vm_user"
    return $?
}

function get_hugepage_used() {
    local flag="${1:-local}"
    if [ "$flag" = "vm" ]; then
        mem_info=$(vm_sshx "grep Huge /proc/meminfo")
    else
        mem_info=$(grep Huge /proc/meminfo)
    fi
    huge_free=$(echo "$mem_info" | grep 'HugePages_Free' | sed 's/\r//' | awk '{print $2}')
    huge_total=$(echo "$mem_info" | grep 'HugePages_Total' | sed 's/\r//' | awk '{print $2}')
    huge_used=$(( (huge_total - huge_free) * 2 ))
    echo "$huge_used"
}

function float_le() {
    local v1=$1
    local v2=$2
    ret=$(echo "$v1 $v2" | awk '{if($1<=$2) {print 0} else {print 1}}')
    [ "$ret" = "0" ] && return 0
    return 1
}

function float_gt() {
    local v1=$1
    local v2=$2
    ret=$(echo "$v1 $v2" | awk '{if($1>$2) {print 0} else {print 1}}')
    [ "$ret" = "0" ] && return 0
    return 1
}

function get_memlink_recycle_hugepagesz() {
    local total=$1
    local used=$2
    local used_percent=$3
    local max_percent=$4
    used_target=$(echo "$used $used_percent 100" | awk '{print $1 * $2 / $3}')
    max_target=$(echo "$total $max_percent 100" | awk '{print $1 * $2 / $3}')
    target="$used_target"
    float_gt "$max_target" "$used_target" && target="$max_target"
    float_le "$target" "1" && target="1"
    echo "$total $target" | awk '{diff = $1 - $2; print (diff >= 0) ? diff : 0}'
}

function check_memlink_recycle() {
    local vm_total=$1
    local vm_used=$2
    local used_percent=$3
    local max_percent=$4
    local flag="${5:-}"
    # allocing 1G
    chmod +x "${OET_PATH}/testcases/smoke-test/smoke-memlink/common/set_memory.sh" || return 1
    sh "${OET_PATH}/testcases/smoke-test/smoke-memlink/common/set_memory.sh" "$vm_name"
    SLEEP_WAIT 60
    os_used_running="$(get_hugepage_used "local")"
    LOG_INFO "os_used_running: $os_used_running"
    # kill stress
    chmod +x "${OET_PATH}/testcases/smoke-test/smoke-memlink/common/unset_memory.sh"  || return 1
    sh "${OET_PATH}/testcases/smoke-test/smoke-memlink/common/unset_memory.sh" "$vm_name"
    SLEEP_WAIT 240
    os_used_free="$(get_hugepage_used "local")"
    LOG_INFO "os_used_free: $os_used_free"
    # check
    diff=$((os_used_running - os_used_free))
    diff=${diff/-/}
    if [ "$flag" = "fail" ]; then
        [ "$diff" -ge "0" ]
    else
        expect_recycle_vm_huge=$(get_memlink_recycle_hugepagesz "$vm_total" "$vm_used" "$used_percent" "$max_percent")
        float_gt "$diff" "$(echo "$expect_recycle_vm_huge * 1024 * 0.6" | bc)"
    fi
    return $?
}

function destroy_vm() {
    local vm_name=$1
    virsh destroy "$vm_name" && SLEEP_WAIT 3
    virsh undefine "$vm_name" --nvram
    virsh list --all
}

function memlink_post() {
    recover_cfg "$MEMLINKD_CONFIG"
    rm -rf "$BACKUP_DIR"
    vm_clean
    set_huge_mem 0
    set_huge_mem 0 "remote"
    setenforce 1
}
