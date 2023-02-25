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
  DNF_INSTALL "libguestfs"
  wget https://mirrors.ustc.edu.cn/centos-cloud/centos/7/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  mv CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/
  virt-install --name centeros-2003 --ram 2048 --vcpus=2 --disk path=/home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2,bus=virtio,format=qcow2 --network=bridge:virbr0 --force --import --autostart --noautoconsole
  virsh destroy centeros-2003
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."

  guestmount -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount -a -m --ro failed"
  guestunmount /mnt
  LOG_INFO "==================01=================="

  guestmount -c test:///default -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount -c failed"
  guestunmount /mnt
  LOG_INFO "==================2=================="

  guestmount -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 --dir-cache-timeout 5 -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount --dir-cache-timeout failed"
  guestunmount /mnt
  LOG_INFO "==================3=================="

  guestmount -d centeros-2003 -i --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount -d failed"
  guestunmount /mnt
  LOG_INFO "==================4=================="

  guestmount -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 --echo-keys -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount --echo-keys failed"
  guestunmount /mnt
  LOG_INFO "==================5=================="

  guestmount --format=qcow2 -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount --format failed"
  guestunmount /mnt
  LOG_INFO "==================6=================="

  guestmount --fuse-help -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 -m /dev/sda1 --ro /mnt 2>&1 | grep 'usage: guestmount'
  CHECK_RESULT $? 0 0 "Check guestmount --fuse-help failed"
  LOG_INFO "==================7=================="

  guestmount --help | grep 'guestmount: FUSE module for libguestfs'
  CHECK_RESULT $? 0 0 "Check guestmount --help failed"
  LOG_INFO "==================8=================="

  guestmount -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 --key ID:key:KEY_STRING -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount --key failed"
  guestunmount /mnt
  LOG_INFO "==================9=================="

  guestmount -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 --echo-keys -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount -echo-keys failed"
  guestunmount /mnt
  LOG_INFO "==================10=================="

  guestmount --live -d centeros-2003 -m /dev/sda1 /mnt
  CHECK_RESULT $? 0 0 "Check guestmount --live failed"
  guestunmount /mnt
  LOG_INFO "==================11=================="

  guestmount -n -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount -n failed"
  guestunmount /mnt
  LOG_INFO "==================13=================="

  guestmount -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 -m /dev/sda1 --ro /mnt -o allow_other
  CHECK_RESULT $? 0 0 "Check guestmount -o failed"
  guestunmount /mnt
  LOG_INFO "==================14=================="

  guestmount --pid-file pidfile.txt -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount --pid-file failed"
  guestunmount /mnt
  LOG_INFO "==================15=================="

  guestmount --selinux -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount --selinux failed"
  guestunmount /mnt
  LOG_INFO "==================16=================="

  guestmount -v -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount -v failed"
  guestunmount /mnt
  LOG_INFO "==================17=================="

  guestmount -V 2>&1 | grep $(rpm -q libguestfs --queryformat '%{version}\n')
  CHECK_RESULT $? 0 0 "Check guestmount -V failed"
  LOG_INFO "==================18=================="

  guestmount -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 -m /dev/sda1 --rw /mnt
  CHECK_RESULT $? 0 0 "Check guestmount -m failed"
  guestunmount /mnt
  LOG_INFO "==================19=================="

  guestmount --no-fork -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 -m /dev/sda1 --ro /mnt &
  CHECK_RESULT $? 0 0 "Check guestmount --no-fork failed"
  guestunmount /mnt
  LOG_INFO "==================12=================="

  #guestmount -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 -x -m /dev/sda1 --ro /mnt
  #CHECK_RESULT $? 0 0 "Check guestmount -x failed"
  #guestunmount /mnt

  LOG_INFO "End to run test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  virsh start centeros-2003
  virsh destroy centeros-2003
  virsh undefine centeros-2003 --nvram
  ps -ef | grep virt | grep -v grep | awk '{print $2}' | xargs kill -9
  DNF_REMOVE
  LOG_INFO "Finish to restore the test environment."
}

main $@
