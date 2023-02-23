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

  virt-filesystems -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-filesystems -a failed"

  virt-filesystems --all -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-filesystems --all failed"

  virt-filesystems --blkdevs -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-filesystems --blkdevs failed"

  virt-filesystems -c test:///default -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-filesystems -c failed"

  virt-filesystems --csv -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-filesystems --csv failed"

  virt-filesystems -d centeros-2003
  CHECK_RESULT $? 0 0 "Check virt-filesystems -d failed"

  virt-filesystems --echo-keys -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-filesystems --echo-keys failed"

  virt-filesystems --extra -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-filesystems --extra failed"

  virt-filesystems --filesystems -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-filesystems -a failed"

  virt-filesystems --format=qcow2 -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-filesystems --format failed"

  virt-filesystems --long -h --all -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-filesystems -h failed"

  virt-filesystems --help 2>&1 | grep 'virt-filesystems'
  CHECK_RESULT $? 0 0 "Check virt-filesystems --help failed"

  virt-filesystems --keys-from-stdin -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-filesystems --keys-from-stdin failed"

  virt-filesystems --long -h --all -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-filesystems --long failed"

  virt-filesystems --lvs -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-filesystems --lvs failed"

  virt-filesystems --no-title -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-filesystems --no-title failed"

  virt-filesystems --parts -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-filesystems --parts failed"

  virt-filesystems --pvs -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-filesystems --pvs failed"

  virt-filesystems --uuid -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-filesystems --uuid failed"

  virt-filesystems -v -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-filesystems -v failed"

  virt-filesystems -V 2>&1 | grep $(rpm -q libguestfs --queryformat '%{version}\n')
  CHECK_RESULT $? 0 0 "Check virt-filesystems -V failed"

  virt-filesystems --vgs -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-filesystems --vgs failed"

  virt-filesystems -x -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
  CHECK_RESULT $? 0 0 "Check virt-filesystems -x failed"

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
