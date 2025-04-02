#!/usr/bin/bash
# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2023/03/02
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of libguestfs common command
# ############################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function libguestfs_pre_test(){
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    libguestfs_pre_test_no_install
    virt-install --name openEuler-2003 --ram 2048 --vcpus=2 --disk path=/home/kvm/images/openEuler-20.03-LTS-SP3.qcow2,bus=virtio,format=qcow2 --network=bridge:virbr0 --force --import --autostart --noautoconsole --graphics none
    virsh destroy openEuler-2003
}

function libguestfs_pre_test_no_install() {
    DNF_INSTALL 'libguestfs virt-manager qemu libvirt openssl-devel numactl numactl-devel libcap-ng-devel traceroute iperf3 python3-paramiko edk2-devel qemu-guest-agent virt-install.noarch'
    if test "$(uname -i)"X == "aarch64"X; then
      LOG_INFO "arm install edk2 pkg"
      DNF_INSTALL edk2-aarch64.noarch
    fi    
    systemctl start libvirtd
    mkdir -p /home/kvm/images
    chown root:root /home/kvm/images
    chmod 755 /home/kvm/images
    LOG_INFO "get $(arch) qcow2 libguestfs pkg"
    if [ ! -f "./common/openEuler-20.03-LTS-SP3-$(arch).qcow2" ];then
      wget https://repo.huaweicloud.com/openeuler/openEuler-20.03-LTS-SP3/virtual_machine_img/"$(arch)"/openEuler-20.03-LTS-SP3-"$(arch)".qcow2.xz --no-check-certificate -O ./common/openEuler-20.03-LTS-SP3-"$(arch)".qcow2.xz 
      xz -d ./common/openEuler-20.03-LTS-SP3-"$(arch)".qcow2.xz
    else
      LOG_INFO "qcow2 file already exists"
    fi
    cp ./common/openEuler-20.03-LTS-SP3-"$(arch)".qcow2 /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2
}

function libguestfs_post_test() {
    export LANG=$OLD_LANG
    virsh start openEuler-2003
    virsh destroy openEuler-2003
    virsh undefine openEuler-2003 --nvram
    unset LIBGUESTFS_DEBUG LIBGUESTFS_TRACE
    DNF_REMOVE "$@"
    rm -rf /home/kvm/images/ a.txt ./*.xz initramfs* output p2v* pidfile* pre-*  qemu-4.2.0* test1.img vmlinuz* file*  
}

function libguestfs_post_test_diff() {
    virsh start openEuler-2003
    virsh start openEuler-2003-1
    virsh destroy openEuler-2003
    virsh undefine openEuler-2003 --nvram
    virsh destroy openEuler-2003-1
    virsh undefine openEuler-2003-1 --nvram
    unset LIBGUESTFS_BACKEND LIBGUESTFS_DEBUG LIBGUESTFS_TRACE
    DNF_REMOVE "$@"
    rm -rf /home/kvm/images/ a.txt ./*.xz initramfs* output p2v* pidfile* pre-*  qemu-4.2.0* test1.img vmlinuz*
}


function libguestfs_post_test_resize() {
    unset LIBGUESTFS_BACKEND LIBGUESTFS_DEBUG LIBGUESTFS_TRACE
    DNF_REMOVE "$@"
    rm -rf /home/kvm/images/ a.txt ./*.xz initramfs* output p2v* pidfile* pre-*  qemu-4.2.0* test1.img vmlinuz*
}
