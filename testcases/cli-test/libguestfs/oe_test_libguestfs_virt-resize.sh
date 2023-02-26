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

  #  virt-install --name centeros-2003 --ram 2048 --vcpus=2 --disk path=/home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2,bus=virtio,format=qcow2 --network=bridge:virbr0 --force --import --autostart --noautoconsole
  #
  #  virt-install --name centeros-2003-1 --ram 2048 --vcpus=2 --disk path=/home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2,bus=virtio,format=qcow2 --network=bridge:virbr0 --force --import --autostart --noautoconsole

  qemu-img create -f qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2 50G

  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."

  virt-resize --align-first never /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check virt-resize --align-first failed"

  virt-resize --alignment 128 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check virt-resize --alignment failed"

  virt-resize --color /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check virt-resize --color failed"

  virt-resize -d /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check virt-resize -d failed"

  virt-resize --delete /dev/sda2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check virt-resize --delete failed"

  virt-resize -n /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check virt-resize -n failed"

  virt-resize --expand /dev/sda2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check virt-resize --expand failed"

  virt-resize --format qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check virt-resize --format failed"

  virt-resize --help | grep 'virt-resize: resize a virtual'
  CHECK_RESULT $? 0 0 "Check virt-resize --help failed"

  virt-resize --ignore /dev/sda2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check virt-resize --ignore failed"

  virt-resize --machine-readable /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check virt-resize --machine-readable failed"

  virt-resize --no-copy-boot-loader /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check virt-resize --no-copy-boot-loader failed"

  virt-resize --no-expand-content /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check virt-resize --no-expand-content failed"

  virt-resize --no-extra-partition /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check virt-resize --no-extra-partition failed"

  virt-resize --no-sparse /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check virt-resize --no-sparse failed"

  virt-resize --ntfsresize-force /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check virt-resize --ntfsresize-force failed"

  virt-resize --output-format raw /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check virt-resize --output-format failed"

  virt-resize -q /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check virt-resize -q failed"

  virt-resize --resize-force /dev/sda1=+128K /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check virt-resize --resize-force failed"

  virt-resize --unknown-filesystems ignore /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check virt-resize --unknown-filesystems failed"

  virt-resize -V | grep $(rpm -q libguestfs --queryformat '%{version}\n')
  CHECK_RESULT $? 0 0 "Check virt-resize -V failed"

  virt-resize -v /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check virt-resize -v failed"

  virt-resize -x /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003-1.qcow2
  CHECK_RESULT $? 0 0 "Check virt-resize -x failed"

  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  DNF_REMOVE
  LOG_INFO "Finish to restore the test environment."
}

main $@
