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
  wget https://mirrors.ustc.edu.cn/centos-cloud/centos/7/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  mv CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/
  cp /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  virt-install --name centeros-2003 --ram 2048 --vcpus=2 --disk path=/home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2,bus=virtio,format=qcow2 --network=bridge:virbr0 --force --import --autostart --noautoconsole
  virt-install --name centeros-2003-1 --ram 2048 --vcpus=2 --disk path=/home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2,bus=virtio,format=qcow2 --network=bridge:virbr0 --force --import --autostart --noautoconsole
  virsh destroy centeros-2003
  virsh destroy centeros-2003-1
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  virt-diff --echo-keys -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 -A /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check guestunmount --echo-keys failed"
  virt-diff --extra-stats -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 -A /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check guestunmount --extra-stats failed"
  virt-diff --format=qcow2 -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 -A /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check guestunmount --format failed"
  virt-diff --help 2>&1 | grep 'virt-diff'
  CHECK_RESULT $? 0 0 "Check guestunmount --help failed"
  virt-diff -h -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 -A /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check guestunmount -h failed"
  virt-diff --key ID:key:KEY_STRING -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 -A /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check guestunmount --key failed"
  virt-diff --keys-from-stdin -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 -A /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check guestunmount --keys-from-stdin failed"
  virt-diff --times -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 -A /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check guestunmount --times failed"
  virt-diff --time-days -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 -A /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check guestunmount --time-days failed"
  CHECK_RESULT $? 0 0 "Check guestunmount --xattrs failed"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  virsh start centeros-2003
  virsh start centeros-2003-1
  virsh destroy centeros-2003
  virsh undefine centeros-2003 --nvram
  virsh destroy centeros-2003-1
  virsh undefine centeros-2003-1 --nvram
  DNF_REMOVE
  LOG_INFO "Finish to restore the test environment."
}

main $@
