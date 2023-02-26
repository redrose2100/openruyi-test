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
  echo "hello" > a.txt
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."

  virt-sysprep --keys-from-stdin -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-sysprep --keys-from-stdin failed"
  virt-sysprep --list-operations -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-sysprep --list-operations failed"
  virt-sysprep --mkdir /etc/dir -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-sysprep --mkdir failed"
  virt-sysprep --mount-options /mnt -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-sysprep --mount-options failed"
  virt-sysprep -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 --move /etc/c.txt:/opt
  CHECK_RESULT $? 0 0 "Check virt-sysprep --move failed"
  virt-sysprep --no-logfile -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-sysprep -help failed"
  virt-sysprep --no-network -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-sysprep --no-network failed"
  virt-sysprep --no-selinux-relabel -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-sysprep --no-selinux-relabel failed"
  virt-sysprep --operation ssh-hostkeys -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-sysprep --operation failed"
  virt-sysprep --password root:password -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-sysprep --password failed"

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
