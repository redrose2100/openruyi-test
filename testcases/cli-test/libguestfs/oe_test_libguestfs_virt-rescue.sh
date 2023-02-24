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

  virt-rescue -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-rescue -a failed"

  virt-rescue -d centeros-2003 -i
  CHECK_RESULT $? 0 0 "Check virt-rescue -d failed"

  virt-rescue --append --blocksize=512 -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-rescue --append --blocksize failed"

  virt-rescue -e ^x -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-rescue -e failed"

  virt-rescue --format=raw -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-rescue --format failed"

  virt-rescue --help
  CHECK_RESULT $? 0 0 "Check virt-rescue --help failed"

  virt-rescue -d centeros-2003 -i
  CHECK_RESULT $? 0 0 "Check virt-rescue -i failed"

  virt-rescue -m /dev/sda1:/:acl,user_xattr -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-rescue -m failed"

  virt-rescue --memsize 256 -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-rescue --memsize failed"

  virt-rescue --ro -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-rescue --ro failed"

  virt-rescue --scratch=3 -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-rescue --scratch failed"

  virt-rescue --selinux -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-rescue --selinux failed"

  virt-rescue --smp 2 -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-rescue --smp failed"

  virt-rescue -v -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-rescue -v failed"

  virt-rescue -V | grep $(rpm -q libguestfs --queryformat '%{version}\n') 2>&1
  CHECK_RESULT $? 0 0 "Check virt-rescue -V failed"

  virt-rescue --rw -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-rescue --rw failed"

  virt-rescue -x -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-rescue -x failed"


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
