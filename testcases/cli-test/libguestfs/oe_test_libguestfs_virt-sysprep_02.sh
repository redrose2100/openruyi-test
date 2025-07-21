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
# @Desc      :   verify the uasge of libguestfs virt-sysprep command
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL 'libguestfs guestfs-tools* virt-manager qemu libvirt openssl-devel numactl numactl-devel libcap-ng-devel traceroute iperf3 python3-paramiko edk2-devel qemu-guest-agent virt-install.noarch'
    if test "$(uname -i)"X == "aarch64"X; then
      LOG_INFO "arm install edk2 pkg"
      DNF_INSTALL edk2-aarch64.noarch
    fi
    systemctl start libvirtd
    mkdir -p /home/kvm/images
    chown root:root /home/kvm/images
    chmod 755 /home/kvm/images
    mkdir -p ./common
    if [[ ${NODE1_FRAME} == "riscv64" ]]; then
      LOG_INFO "get riscv64 qcow2 libguestfs pkg"
      DNF_INSTALL "unzip qemu-system-riscv"
      wget https://gitlab.com/api/v4/projects/giomasce%2Fdqib/jobs/artifacts/master/download?job=convert_riscv64-virt -O debian_riscv.zip --no-check-certificate
      unzip -j debian_riscv.zip dqib_riscv64-virt/image.qcow2 -d /home/kvm/images/
      mv /home/kvm/images/image.qcow2 /home/kvm/images/debian-riscv.qcow2
    elif test "$(uname -i)"X == "x86_64"X; then
      LOG_INFO "get x86 qcow2 libguestfs pkg"
      wget https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-2003.qcow2 --no-check-certificate
      mv CentOS-7-x86_64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-GenericCloud-2003.qcow2
    else
      LOG_INFO "get arm qcow2 libguestfs pkg"
      wget https://cloud.centos.org/centos/7/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 --no-check-certificate
      mv CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-GenericCloud-2003.qcow2
    fi
    if [[ ${NODE1_FRAME} == "riscv64" ]]; then
      virt-install --name debian-riscv64 --ram 2048 --vcpus=2 --disk path=/home/kvm/images/debian-riscv.qcow2,bus=virtio,format=qcow2 --virt-type qemu  --network=bridge:virbr0 --force --import --noautoconsole --graphics none --os-variant unknown
      virsh destroy debian-riscv64
      VIRT_NAME="debian-riscv64"
      OS_NAME="debian-riscv"
    else
      virt-install --name centeros-2003 --ram 2048 --vcpus=2 --disk path=/home/kvm/images/CentOS-7-GenericCloud-2003.qcow2,bus=virtio,format=qcow2 --network=bridge:virbr0 --force --import --noautoconsole --graphics none --os-variant unknown
      virsh destroy centeros-2003
      VIRT_NAME="centeros-2003"
      OS_NAME="CentOS-7-GenericCloud-2003"
    fi
    echo "hello" >a.txt
    virt-copy-in -a "/home/kvm/images/${OS_NAME}.qcow2" a.txt /etc
    unset LIBGUESTFS_BACKEND
    export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    virt-sysprep -n -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-sysprep -n failed"
    virt-sysprep --echo-keys -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-sysprep --echo-keys failed"
    virt-sysprep -a "/home/kvm/images/${OS_NAME}.qcow2" --edit /etc/a.txt:Str
    CHECK_RESULT $? 0 0 "Check virt-sysprep --edit failed"
    virt-sysprep --enable ssh-hostkeys,udev-persistent-net -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-sysprep --enable failed"
    virt-sysprep --firstboot-command cat -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-sysprep --firstboot-command failed"
    virt-sysprep --firstboot-install PKG -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-sysprep --firstboot-install failed"
    virt-sysprep --format qcow2 -a "/home/kvm/images/${OS_NAME}.qcow2"
    CHECK_RESULT $? 0 0 "Check virt-sysprep --format failed"
    virt-sysprep --help 2>&1 | grep 'virt-sysprep'
    CHECK_RESULT $? 0 0 "Check virt-sysprep -help failed"
    virt-sysprep --hostname 8899 -a "/home/kvm/images/${OS_NAME}.qcow2"
    CHECK_RESULT $? 0 0 "Check virt-sysprep --hostname failed"
    virt-sysprep --key ID:key:KEY_STRING -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-sysprep --key failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    if [[ ${NODE1_FRAME} == "riscv64" ]]; then
      virsh start debian-riscv64
      virsh destroy debian-riscv64
      virsh undefine debian-riscv64 --nvram
    else
      virsh start centeros-2003
      virsh destroy centeros-2003
      virsh undefine centeros-2003 --nvram
    fi
    unset LIBGUESTFS_BACKEND LIBGUESTFS_DEBUG LIBGUESTFS_TRACE
    DNF_REMOVE "$@"
    rm -rf debian_riscv.zip /home/kvm/images/
    LOG_INFO "Finish to restore the test environment."
}

main "$@"
