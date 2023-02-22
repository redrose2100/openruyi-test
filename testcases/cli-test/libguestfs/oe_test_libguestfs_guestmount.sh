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
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."

  guestmount -a /home/kvm/images/vm3_3.img -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount -a -m --ro failed"
  guestunmount /mnt

  guestmount -c test:///default -a /home/kvm/images/vm3_3.img -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount -c failed"
  guestunmount /mnt

  guestmount -a /home/kvm/images/vm3_3.img --dir-cache-timeout 5 -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount --dir-cache-timeout failed"
  guestunmount /mnt

  guestmount -d vm3_3 -i --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount -d failed"
  guestunmount /mnt

  guestmount -a /home/kvm/images/vm3_3.img --echo-keys -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount --echo-keys failed"
  guestunmount /mnt

  guestmount --format=raw -a /home/kvm/images/vm3_3.img -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount --format failed"
  guestunmount /mnt

  guestmount --fuse-help -a /home/kvm/images/vm3_3.img -m /dev/sda1 --ro /mnt 2>&1 | grep 'usage: guestmount'
  CHECK_RESULT $? 0 0 "Check guestmount --fuse-help failed"
  guestunmount /mnt

  guestmount --help | grep 'guestmount: FUSE module for libguestfs'
  CHECK_RESULT $? 0 0 "Check guestmount --help failed"

  guestmount -a /home/kvm/images/vm3_3.img --key ID:key:KEY_STRING -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount --key failed"
  guestunmount /mnt

  guestmount -a /home/kvm/images/vm3_3.img --echo-keys -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount -echo-keys failed"
  guestunmount /mnt

  guestmount --live -d vm3_3 -m /dev/sda1 /mnt
  CHECK_RESULT $? 0 0 "Check guestmount --live failed"
  guestunmount /mnt

  guestmount --no-fork -a /home/kvm/images/vm3_3.img -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount --no-fork failed"
  guestunmount /mnt

  guestmount -n -a /home/kvm/images/vm3_3.img -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount -n failed"
  guestunmount /mnt

  guestmount -a /home/kvm/images/vm3_3.img -m /dev/sda1 --ro /mnt -o allow_other
  CHECK_RESULT $? 0 0 "Check guestmount -o failed"
  guestunmount /mnt

  guestmount --pid-file pidfile.txt -a /home/kvm/images/vm3_3.img -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount --pid-file failed"
  guestunmount /mnt

  guestmount --selinux -a /home/kvm/images/vm3_3.img -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount --selinux failed"
  guestunmount /mnt

  guestmount -v -a /home/kvm/images/vm3_3.img -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount -v failed"
  guestunmount /mnt

  guestmount -V 2>&1 | grep $(rpm -q libguestfs --queryformat '%{version}\n')
  CHECK_RESULT $? 0 0 "Check guestmount -V failed"
  guestunmount /mnt

  guestmount -a /home/kvm/images/vm3_3.img -m /dev/sda1 --rw /mnt
  CHECK_RESULT $? 0 0 "Check guestmount -m failed"
  guestunmount /mnt

  guestmount -a /home/kvm/images/vm3_3.img -x -m /dev/sda1 --ro /mnt
  CHECK_RESULT $? 0 0 "Check guestmount -x failed"
  guestunmount /mnt

  LOG_INFO "End to run test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  ps -ef | grep guest | grep -v grep | awk '{print $2}' | xargs kill -9
  ps -ef | grep virt | grep -v grep | awk '{print $2}' | xargs kill -9
  DNF_INSTALL
  LOG_INFO "Finish to restore the test environment."
}

main $@
