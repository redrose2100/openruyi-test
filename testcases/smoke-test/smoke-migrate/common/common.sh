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
if [ -f /etc/yum.repos.d/openEuler.repo ]; then
    repo_baseurl=$(awk -F= '/baseurl/ {print $2; exit}' /etc/yum.repos.d/openEuler.repo | grep -o '^.*/openEuler-[^/]*')
    version=$(basename "${repo_baseurl}")
else
    version=$(curl -skL https://repo.openeuler.org | grep -oE 'openEuler-[0-9]+\.[0-9]+-LTS(-SP[0-9]+)?' | sort -uV | tail -n 1)
    repo_baseurl="https://repo.openeuler.org/${version}"
fi
image_path_base="${image_dir}/${version}-aarch64.qcow2"
image_download_url="${repo_baseurl}/virtual_machine_img/aarch64/${version}-aarch64.qcow2.xz"

vm_ip="192.168.1.101"
vm_user="root"
vm_passwd="openEuler12#$"

function vm_clean() {
    local flag=${1:-local}
    if [ "${flag}" = "local" ]; then
        virsh list --all --name | xargs -I {} virsh destroy {}
        virsh list --all --name | xargs -I {} virsh undefine {} --nvram
    elif [ "${flag}" = "remote" ]; then
        SSH_CMD "virsh list --all --name | xargs -I {} virsh destroy {}" "$NODE2_IPV4" "$NODE2_PASSWORD" "$NODE2_USER"
        SSH_CMD "virsh list --all --name | xargs -I {} virsh undefine {} --nvram" "$NODE2_IPV4" "$NODE2_PASSWORD" "$NODE2_USER"
    fi
}

function share_image() {
    systemctl start rpcbind
    systemctl start rpc-statd
    echo "$image_dir *(rw,sync,no_subtree_check,no_root_squash)" > /etc/exports
    systemctl restart nfs-server
    SSH_CMD "mount -t nfs $NODE1_IPV4:$image_dir $image_dir" "$NODE2_IPV4" "$NODE2_PASSWORD" "$NODE2_USER"
    SSH_CMD "df -h" "$NODE2_IPV4" "$NODE2_PASSWORD" "$NODE2_USER"
}

function unshare_image() {
    SSH_CMD "umount -l $image_dir" "$NODE2_IPV4" "$NODE2_PASSWORD" "$NODE2_USER"
    systemctl stop nfs-server
    SSH_CMD "df -h" "$NODE2_IPV4" "$NODE2_PASSWORD" "$NODE2_USER"
}

function pre_init() {
    if [ "$(arch)" != "aarch64" ]; then
        echo "migrate仅支持ARM架构，非ARM架构跳过测试"
        exit 255
    fi
    # pkg pre
    SSH_CMD "mkdir -p $test_qemu_dir" "$NODE2_IPV4" "$NODE2_PASSWORD" "$NODE2_USER"
    chmod +x "${OET_PATH}/testcases/smoke-test/smoke-migrate/common/pkg_pre.sh"
    sh "${OET_PATH}/testcases/smoke-test/smoke-migrate/common/pkg_pre.sh"
    SSH_SCP "${OET_PATH}/testcases/smoke-test/smoke-migrate/common/pkg_pre.sh" "${NODE2_USER}@${NODE2_IPV4}:${test_qemu_dir}" "$NODE2_PASSWORD"
    SSH_CMD "sh ${test_qemu_dir}/pkg_pre.sh" "$NODE2_IPV4" "$NODE2_PASSWORD" "$NODE2_USER" "1200"
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
    share_image
    # xml pre
    mkdir -p "$config_dir"
    cp -arvf ../config "$test_qemu_dir"
    SSH_CMD "mkdir -p $config_dir" "$NODE2_IPV4" "$NODE2_PASSWORD" "$NODE2_USER" 
    SSH_SCP ../config "${NODE2_USER}@${NODE2_IPV4}:${test_qemu_dir}" "$NODE2_PASSWORD"
    # net pre
    systemctl disable firewalld
    SSH_CMD "systemctl disable firewalld" "$NODE2_IPV4" "$NODE2_PASSWORD" "$NODE2_USER"
    sysctl -w kernel.numa_balancing=0
    echo 1 > /proc/sys/net/ipv4/ip_forward
    iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -j MASQUERADE
    iptables -A FORWARD -i QEMU_br0 -j ACCEPT
    iptables -A FORWARD -o QEMU_br0 -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -L FORWARD -v -n
    SSH_CMD "sysctl -w kernel.numa_balancing=0;
             echo 1 > /proc/sys/net/ipv4/ip_forward;
             iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -j MASQUERADE;
             iptables -A FORWARD -i QEMU_br0 -j ACCEPT;
             iptables -A FORWARD -o QEMU_br0 -m state --state RELATED,ESTABLISHED -j ACCEPT;
             iptables -L FORWARD -v -n" "$NODE2_IPV4" "$NODE2_PASSWORD" "$NODE2_USER"
    brctl addbr br0
    ifconfig br0 192.168.1.99/24 up
    SSH_CMD "brctl addbr br0; ifconfig br0 192.168.1.100/24 up" "$NODE2_IPV4" "$NODE2_PASSWORD" "$NODE2_USER"
    # config
    sysctl kernel.softlockup_panic | grep 0 || {
        sysctl kernel.softlockup_panic=0
        sysctl -p
    }
    setenforce 0
    SSH_CMD "setenforce 0" "$NODE2_IPV4" "$NODE2_PASSWORD" "$NODE2_USER"
    # vm clean
    vm_clean "local"
    vm_clean "remote"
    rm -rf /var/log/libvirt/libvirtd.log*; rm -rf /var/log/libvirt/qemu/*
    SSH_CMD "rm -rf /var/log/libvirt/libvirtd.log*;
             rm -rf /var/log/libvirt/qemu/*" "$NODE2_IPV4" "$NODE2_PASSWORD" "$NODE2_USER"
}

function memlink_init() {
    command -v numactl || yum install -y numactl
    rpm -q memlinkd || yum install -y memlinkd
    systemctl is-active --quiet memlinkd || systemctl restart memlinkd
}

function set_huge_mem() {
    local huge_size=$1
    local flag=${2:-local}
    local huge_2M="/sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages"
    if [ "${flag}" = "local" ]; then
        echo "$huge_size" > "$huge_2M"
        SLEEP_WAIT 10
        output=$(grep HugePages_ /proc/meminfo)
    elif [ "${flag}" = "remote" ]; then
        SSH_CMD "echo $huge_size > $huge_2M" "$NODE2_IPV4" "$NODE2_PASSWORD" "$NODE2_USER"
        SLEEP_WAIT 10
        output=$(SSH_CMD "grep HugePages_ /proc/meminfo" "$NODE2_IPV4" "$NODE2_PASSWORD" "$NODE2_USER")
    fi
    total_local=$(echo "$output" | grep "HugePages_Total:" | sed 's/\r//' | awk '{print int($2)}')
    [ "$total_local" -ge "$huge_size" ] || LOG_WARN "set hugepage failed"
}

function set_huge_mem_1_2() {
    local huge_size_local=$1
    local huge_size_remote=$2
    set_huge_mem "$huge_size_local"
    set_huge_mem "$huge_size_remote" "remote"
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

function mig_set_max_downtime() {
    local vm_name=$1
    local max_downtime=$2
    local flag=${3:-local}
    if [ "$flag" = "local" ]; then
        virsh migrate-setmaxdowntime "$vm_name" "$max_downtime" || return 1
    elif [ "$flag" = "remote" ]; then
        SSH_CMD "virsh migrate-setmaxdowntime $vm_name $max_downtime" "$NODE2_IPV4" "$NODE2_PASSWORD" "$NODE2_USER" || return 1
    fi
    LOG_INFO "set the max downtime for migration on $vm_name: $max_downtime"
    return 0
}

function mig_vm() {
    local vm_name=$1
    local parallel_conn=$2
    local trans_type=$3
    local onecopy=${4:-""}
    mig_set_max_downtime "$vm_name" 10000
    mig_cmd="time virsh migrate --p2p --live --unsafe --migrateuri ${trans_type}://${NODE2_IPV4} ${vm_name} --listen-address ${NODE2_IPV4} qemu+tcp://${NODE2_IPV4}/system --verbose --parallel --parallel-connections ${parallel_conn} --rdma-pin-all ${onecopy}"
    LOG_INFO "$mig_cmd"
    eval "$mig_cmd"
}

function mig_vm_back() {
    local vm_name=$1
    local parallel_conn=$2
    local trans_type=$3
    local onecopy=${4:-""}
    mig_set_max_downtime "$vm_name" 10000 "remote"
    mig_cmd="time virsh migrate --p2p --live --unsafe --migrateuri ${trans_type}://${NODE1_IPV4} ${vm_name} --listen-address ${NODE1_IPV4} qemu+tcp://${NODE1_IPV4}/system --verbose --parallel --parallel-connections ${parallel_conn} --rdma-pin-all ${onecopy}"
    LOG_INFO "$mig_cmd"
    SSH_CMD "$mig_cmd" "$NODE2_IPV4" "$NODE2_PASSWORD" "$NODE2_USER" "3600"
}

function check_vm_exist() {
    local vm_name=$1
    local flag=${2:-local}
    if [ "$flag" = "local" ]; then
        virsh list --all | grep "$vm_name"
    elif [ "$flag" = "remote" ]; then
        SSH_CMD "virsh list --all | grep $vm_name" "$NODE2_IPV4" "$NODE2_PASSWORD" "$NODE2_USER"
    fi
    return $?
}

function destroy_vm() {
    local vm_name=$1
    virsh destroy "$vm_name" && SLEEP_WAIT 3
    virsh undefine "$vm_name" --nvram
    virsh list --all
}

function post_clean() {
    vm_clean "local"
    vm_clean "remote"
    unshare_image
    setenforce 1
    SSH_CMD "setenforce 1" "$NODE2_IPV4" "$NODE2_PASSWORD" "$NODE2_USER"
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
    chmod +x "${OET_PATH}/testcases/smoke-test/smoke-migrate/common/set_memory.sh" || return 1
    sh "${OET_PATH}/testcases/smoke-test/smoke-migrate/common/set_memory.sh" "$vm_name"
    SLEEP_WAIT 60
    os_used_running="$(get_hugepage_used "local")"
    LOG_INFO "os_used_running: $os_used_running"
    # kill stress
    chmod +x "${OET_PATH}/testcases/smoke-test/smoke-migrate/common/unset_memory.sh"  || return 1
    sh "${OET_PATH}/testcases/smoke-test/smoke-migrate/common/unset_memory.sh" "$vm_name"
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
