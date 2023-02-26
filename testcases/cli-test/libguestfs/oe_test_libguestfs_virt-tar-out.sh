#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2022/11/22
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of libguestfs command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL libguestfs

  wget https://download.qemu.org/qemu-4.2.0.tar.xz
  xz -dk qemu-4.2.0.tar.xz

  wget https://mirrors.ustc.edu.cn/centos-cloud/centos/7/images/CentOS-7-aarch64-GenericCloud-2003.qcow2

  mv CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/

  virt-install --name centeros-2003 --ram 2048 --vcpus=2 --disk path=/home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2,bus=virtio,format=qcow2 --network=bridge:virbr0 --force --import --noautoconsole

  virsh destroy centeros-2003
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."

  virt-tar-out -d centeros-2003 /etc/ qemu-4.2.0.tar
  CHECK_RESULT $? 0 0 "Check virt-copy-in -d failed"

  virt-tar-out -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /etc/ qemu-4.2.0.tar
  CHECK_RESULT $? 0 0 "Check virt-copy-in -a failed"

  virt-tar-out -V 2>&1 | grep $(rpm -q libguestfs --queryformat '%{version}\n')
  CHECK_RESULT $? 0 0 "Check virt-copy-in -V failed"

  virt-tar-out -h 2>&1 | grep 'display a list of commands'
  CHECK_RESULT $? 0 0 "Check virt-copy-in -h failed"

  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  virsh start centeros-2003
  virsh destroy centeros-2003
  virsh undefine centeros-2003 --nvram
  DNF_REMOVE
  LOG_INFO "Finish to restore the test environment."
}

main $@
