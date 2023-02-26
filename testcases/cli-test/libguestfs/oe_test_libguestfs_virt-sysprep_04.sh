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
  echo "hello" >a.txt
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."

  virt-sysprep --password root:password -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-sysprep --password failed"
  virt-sysprep --password-crypto md5 -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-sysprep --password-crypto failed"
  virt-sysprep -q -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-sysprep -q failed"
  virt-sysprep --root-password password -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-sysprep --root-password failed"
  virt-sysprep --run-command cat -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-sysprep ---run-command failed"
  virt-sysprep --scriptdir /etc/tmp -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-sysprep --scriptdir failed"
  virt-sysprep --scrub /etc/a.txt --scrub centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-sysprep -help failed"
  virt-sysprep --selinux-relabel -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-sysprep --selinux-relabel failed"
  virt-sysprep --timezone Europe/London -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-sysprep --timezone failed"
  virt-sysprep --touch /etc/a.txt -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-sysprep --touch failed"

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
