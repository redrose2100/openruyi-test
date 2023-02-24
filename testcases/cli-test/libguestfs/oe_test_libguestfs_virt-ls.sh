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

  virt-ls --format=qcow2 -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /etc
  CHECK_RESULT $? 0 0 "Check virt-ls -a failed"

  virt-ls -lR -d centeros-2003 --checksum=md5 --time-days /etc/ | awk '$6 <= 7'
  CHECK_RESULT $? 0 0 "Check virt-ls -lR failed"

  virt-ls -c test:///default -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /etc
  CHECK_RESULT $? 0 0 "Check virt-ls -c failed"

  virt-ls --csv -lR -d centeros-2003 --time-days /etc/ | awk '$6 <= 7'
  CHECK_RESULT $? 0 0 "Check virt-ls --csv failed"

  virt-ls -d centeros-2003 /etc
  CHECK_RESULT $? 0 0 "Check virt-ls -d failed"

  virt-ls -lR -d centeros-2003 --echo-keys /etc/ | awk '$6 <= 7'
  CHECK_RESULT $? 0 0 "Check virt-ls --echo-keys failed"

  virt-ls -lR --extra-stats -d centeros-2003 /etc/ | awk '$6 <= 7'
  CHECK_RESULT $? 0 0 "Check virt-ls --extra-stats failed"

  virt-ls --format=qcow2 -a /home/kvm/images/CentOS-7-aarch64-GenericCloud-2003.qcow2 /etc
  CHECK_RESULT $? 0 0 "Check virt-ls --format failed"

  virt-ls --help | grep 'virt-ls: list'
  CHECK_RESULT $? 0 0 "Check virt-ls --help failed"

  virt-ls -h -lR -d centeros-2003 --time-days /etc/ | awk '$6 <= 7'
  CHECK_RESULT $? 0 0 "Check virt-ls -h failed"

  virt-ls --key ID:key:KEY_STRING -lR -d centeros-2003 --time-days /etc/ | awk '$6 <= 7'
  CHECK_RESULT $? 0 0 "Check virt-ls --key failed"

  virt-ls --keys-from-stdin -lR -d centeros-2003 --time-days /etc/ | awk '$6 <= 7'
  CHECK_RESULT $? 0 0 "Check virt-ls --keys-from-stdin failed"

  virt-ls -l -lR -d centeros-2003 --time-days /etc/ | awk '$6 <= 7'
  CHECK_RESULT $? 0 0 "Check virt-ls -lR failed"

  virt-ls -R -d centeros-2003 /etc/
  CHECK_RESULT $? 0 0 "Check virt-ls -R failed"

  virt-ls -lR --times -d centeros-2003 /etc/ | awk '$6 <= 7'
  CHECK_RESULT $? 0 0 "Check virt-ls --times failed"

  virt-ls -lR -d centeros-2003 --time-days /etc/ | awk '$6 <= 7'
  CHECK_RESULT $? 0 0 "Check virt-ls --time-days failed"

  virt-ls -lR --time-relative -d centeros-2003 /etc/
  CHECK_RESULT $? 0 0 "Check virt-ls --time-relative failed"

  virt-ls -lR --time-t -d centeros-2003 /etc/
  CHECK_RESULT $? 0 0 "Check virt-ls -time-t failed"

  virt-ls -lR --uids -d centeros-2003 /etc/
  CHECK_RESULT $? 0 0 "Check virt-ls --uids failed"

  virt-ls -v -d centeros-2003 /etc/
  CHECK_RESULT $? 0 0 "Check virt-ls -v failed"

  virt-ls -V | grep $(rpm -q libguestfs --queryformat '%{version}\n')
  CHECK_RESULT $? 0 0 "Check virt-ls -V failed"

  virt-ls -x -d centeros-2003 /etc/
  CHECK_RESULT $? 0 0 "Check virt-ls -x failed"

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
