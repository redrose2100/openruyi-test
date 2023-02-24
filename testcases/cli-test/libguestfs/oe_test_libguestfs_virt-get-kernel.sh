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

  virt-install --name centeros-2003 --ram 2048 --vcpus=2 --disk path=/home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2,bus=virtio,format=qcow2 --network=bridge:virbr0 --force --import --autostart --noautoconsole

  virsh destroy centeros-2003
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  virt-get-kernel -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check guestunmount -a failed"

  virt-get-kernel -c test:///default -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check guestunmount -c failed"

  virt-get-kernel -d centeros-2003
  CHECK_RESULT $? 0 0 "Check guestunmount -d failed"

  virt-get-kernel --echo-keys -d centeros-2003
  CHECK_RESULT $? 0 0 "Check guestunmount --echo-keys failed"

  virt-get-kernel --format=qcow2 -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check guestunmount --format failed"

  virt-get-kernel --help 2>&1 | grep 'virt-get-kernel'
  CHECK_RESULT $? 0 0 "Check guestunmount --help failed"

  virt-get-kernel --key ID:key:KEY_STRING -d centeros-2003
  CHECK_RESULT $? 0 0 "Check guestunmount --key failed"

  virt-get-kernel --keys-from-stdin -d centeros-2003
  CHECK_RESULT $? 0 0 "Check guestunmount --keys-from-stdin failed"

  virt-get-kernel --machine-readable 2>&1 | grep 'virt'
  CHECK_RESULT $? 0 0 "Check guestunmount --machine-readable failed"

  virt-get-kernel -o /etc/ -d centeros-2003
  CHECK_RESULT $? 0 0 "Check guestunmount -o failed"

  virt-get-kernel --prefix pre -d centeros-2003
  CHECK_RESULT $? 0 0 "Check guestunmount --prefix failed"

  virt-get-kernel -q -d centeros-2003
  CHECK_RESULT $? 0 0 "Check guestunmount -q failed"

  virt-get-kernel --unversioned-names -d centeros-2003
  CHECK_RESULT $? 0 0 "Check guestunmount --unversioned-names failed"

  virt-get-kernel -V | grep $(rpm -q libguestfs --queryformat '%{version}\n') 2>&1
  CHECK_RESULT $? 0 0 "Check guestunmount -V failed"

  virt-get-kernel -v -d centeros-2003
  CHECK_RESULT $? 0 0 "Check guestunmount -v failed"

  virt-get-kernel -x -d centeros-2003
  CHECK_RESULT $? 0 0 "Check guestunmount -x failed"

  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  virsh destroy centeros-2003
  virsh undefine centeros-2003 --nvram
  ps -ef | grep virt | grep -v grep | awk '{print $2}' | xargs kill -9
  DNF_INSTALL
  LOG_INFO "Finish to restore the test environment."
}

main $@
