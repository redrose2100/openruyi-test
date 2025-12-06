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
#@Date      	:   2025-12-06
#@License   	:   Mulan PSL v2
#@Desc      	:   Public function
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

test_qemu_dir="/home/test_qemu"
config_dir="${test_qemu_dir}/config"
image_dir="${test_qemu_dir}/image"
image_path="${image_dir}/openEuler.qcow2"
repo_baseurl=$(grep -A 5 "\[openEuler\]" /etc/yum.repos.d/openEuler.repo | grep baseurl | cut -d= -f2)
image_download_url="${repo_baseurl//everything\/aarch64\//virtual_machine_img\/aarch64\/openEuler-24.03-LTS-SP3-aarch64.qcow2.xz}"

vm_ip="192.168.1.101"
vm_user="root"
vm_passwd="openEuler12#$"

function ub_env_init() {
    # img pre
    mkdir -p "$image_dir"
    if [ ! -f "$image_path" ]; then
        wget -N -O "$image_path".xz "$image_download_url" --timeout=30 --tries=1
        unxz "$image_path".xz
    fi
    # xml pre
    mkdir -p "$config_dir"
    cp -arvf ../config "$test_qemu_dir"
    # pkg pre
    chmod +x "${OET_PATH}/testcases/smoke-test/smoke-ubnative/common/pkg_pre.sh"
    sh "${OET_PATH}/testcases/smoke-test/smoke-ubnative/common/pkg_pre.sh"
    # net pre
    systemctl disable firewalld
    brctl addbr br0
    ifconfig br0 192.168.1.99/24 up
    # ub pre
    modprobe vfio
    modprobe vfio-ub
    # config
    setenforce 0
    # vm clean
    virsh list --all --name | xargs -I {} virsh destroy {}
    virsh list --all --name | xargs -I {} virsh undefine {} --nvram
    rm -rf /var/log/libvirt/libvirtd.log*
    rm -rf /var/log/libvirt/qemu/*
}

function set_hugepages() {
    local num=$1
    cur_num=$(cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages)
    if [ "$cur_num" -lt "$num" ]; then
        echo "$num" > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
    fi
}

function ub_dev_init() {
    local bus_instance=$1
    local ub_dev_ids=$2
    setub -b create -g "$bus_instance" -e 0xffff6 -u 1
    for ub_dev_id in $ub_dev_ids; do
        ub_dev_guid=$(cat /sys/bus/ub/devices/"$ub_dev_id"/guid)
        setub -b bind -d "$ub_dev_guid" -g "$bus_instance"
        echo "$ub_dev_id" > /sys/bus/ub/devices/"${ub_dev_id}"/driver/unbind
        echo vfio-ub > /sys/bus/ub/devices/"${ub_dev_id}"/driver_override
        echo "$ub_dev_id" > /sys/bus/ub/drivers_probe
        ls -ln /sys/bus/ub/devices/"${ub_dev_id}"/driver
    done
}

function create_vm_waiting_running() {
    local vm_name=$1
    local bus_instance=$2
    local ub_dev_ids=$3
    xml_path="${config_dir}/${vm_name}.xml"
    qcow2_path="$image_path"
    [ ! -f "$xml_path" ] && {
        LOG_ERROR "$xml_path does not exist"
        return 1
    }
    sed -i "s|IMAGE_PATH|${qcow2_path}|g" "$xml_path"
    sed -i "s|BUS_INSTANCE|${bus_instance}|g" "$xml_path"
    for ub_dev_id in $ub_dev_ids; do
        ub_dev_guid=$(cat /sys/bus/ub/devices/"$ub_dev_id"/guid)
        sed -i "s|UB_DEV_GUID|${ub_dev_guid}|g" "$xml_path"
    done
    LOG_INFO "vm xml save dir: $xml_path; image dir is: $qcow2_path"
    virsh define "$xml_path" && virsh start "$vm_name" || return 1
    sleep 60
    virsh list | grep "$vm_name"
    return $?
}

function wait_exec() {
    local cmd=$1
    local count=${2:-60}
    for ((i = 1; i <= count; i++)); do
        LOG_INFO "[$i] wait in cmd: ${cmd}..."
        eval "${cmd}" &> /dev/null && return 0
        sleep 2
    done
    LOG_WARN "${cmd} timeout failed"
    return 1
}

function vm_sshx() {
    local cmd=$1
    local vm_ip="${2:-${vm_ip}}"
    SSH_CMD "$cmd" "$vm_ip" "$vm_passwd" "$vm_user"
    return $?
}

function vm_modprobe_ko() {
    local vm_ip="${1:-${vm_ip}}"
    SSH_CMD "modprobe ubfi; 
             modprobe ummu-core; 
             modprobe ummu; 
             modprobe ubus;
             modprobe hisi_ubus;
             modprobe ubase;
             modprobe unic" "$vm_ip" "$vm_passwd" "$vm_user"
}

function destroy_vm() {
    local vm_name=$1
    virsh destroy "$vm_name" && sleep 3
    virsh undefine "$vm_name" --nvram
    virsh list --all
}

function ub_dev_restore() {
    local bus_instance=$1
    local ub_dev_ids=$2
    for ub_dev_id in $ub_dev_ids; do
        echo "$ub_dev_id" > /sys/bus/ub/devices/"${ub_dev_id}"/driver/unbind
        echo ubase > /sys/bus/ub/devices/"${ub_dev_id}"/driver_override
        echo "$ub_dev_id" > /sys/bus/ub/drivers_probe
        ls -ln /sys/bus/ub/devices/"${ub_dev_id}"/driver
        ub_dev_guid=$(cat /sys/bus/ub/devices/"$ub_dev_id"/guid)
        setub -b unbind -d "$ub_dev_guid" -g "$bus_instance"
    done
    setub -b destroy -g "$bus_instance"
}
