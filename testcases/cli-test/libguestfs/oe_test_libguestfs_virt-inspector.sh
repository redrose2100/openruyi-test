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

  virt-install --name centeros-2003 --ram 2048 --vcpus=2 --disk path=/home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2,bus=virtio,format=qcow2 --network=bridge:virbr0 --force --import --noautoconsole

  virsh destroy centeros-2003
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."

  virt-inspector -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 | grep 'operatingsystems'
  CHECK_RESULT $? 0 0 "Check guestunmount -a failed"

  virt-inspector -c test:///default -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 | grep 'operatingsystems'
  CHECK_RESULT $? 0 0 "Check guestunmount -c failed"

  virt-inspector -d centeros-2003
  CHECK_RESULT $? 0 0 "Check guestunmount -d failed"

  virt-inspector --echo-keys -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check guestunmount --echo-keys failed"

  virt-inspector --format=raw -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check guestunmount --format failed"

  virt-inspector --help | grep 'virt-inspector: display'
  CHECK_RESULT $? 0 0 "Check guestunmount --help failed"

  virt-inspector --key "DEVICE":key:KEY_STRING -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check guestunmount --key failed"

  virt-inspector --keys-from-stdin -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check guestunmount --keys-from-stdin failed"

  virt-inspector --no-applications -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check guestunmount --help failed"

  virt-inspector --no-icon -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check guestunmount --no-applications failed"

  virt-inspector -v -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check guestunmount -v failed"

  virt-inspector -V | grep $(rpm -q libguestfs --queryformat '%{version}\n')
  CHECK_RESULT $? 0 0 "Check guestunmount -V failed"

  virt-inspector -x -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check guestunmount -x failed"

  virt-inspector -d vm22 | virt-inspector --xpath '//filesystems'
  CHECK_RESULT $? 0 0 "Check guestunmount --xpath failed"

  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  virsh start centeros-2003
  virsh destroy centeros-2003
  virsh undefine centeros-2003 --nvram
  ps -ef | grep virt | grep -v grep | awk '{print $2}' | xargs kill -9
  DNF_INSTALL
  LOG_INFO "End to restore the test environment."
}

main $@
