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

  guestmount -a 1.img -m /dev/sda1 --ro /mnt
  guestmount -c test:///default -a 1.img -m /dev/sda --ro /mnt
  guestmount -a 1.img --dir-cache-timeout 5 -m /dev/sda1 --ro /mnt
  guestmount -d vm1 -i --ro /mnt
  guestmount -a 1.img --echo-keys -m /dev/sda1 --ro /mnt
  guestmount --format=raw -a 1.img -m /dev/sda1 --ro /mnt
  guestmount --fuse-help -a 1.img -m /dev/sda1 --ro /mnt 2>&1 | grep 'usage: guestmount'
  guestmount -d vm1 -i --ro /mnt
  guestmount --help | grep 'guestmount: FUSE module for libguestfs'

  guestmount -a 1.img --key ID:key:KEY_STRING -m /dev/sda1 --ro /mnt
  guestmount -a 1.img --echo-keys -m /dev/sda1 --ro /mnt
  bguestmount --live -d vm106 -m /dev/sda1 /mnt
  guestmount -a 1.img -m /dev/sda1 --ro /mnt
  guestmount --no-fork -a 1.img -m /dev/sda1 --ro /mnt
  guestmount -n -a 1.img -m /dev/sda1 --ro /mnt
  guestmount -a 1.img -m /dev/sda1 --ro /mnt -o allow_other
  guestmount --pid-file pidfile.txt -a 1.img -m /dev/sda1 --ro /mnt
  guestmount -a 1.img -m /dev/sda1 --ro /mnt
  guestmount --selinux -a 1.img -m /dev/sda1 --ro /mnt

  guestmount -v -a 1.img -m /dev/sda1 --ro /mnt
  guestmount -V | grep $(rpm -q libguestfs --queryformat '%{version}\n') 2>&1
  CHECK_RESULT $? 0 0 "Check guestmount -V failed"
  guestmount -a 1.img -m /dev/sda1 --rw /mnt
  guestmount -a 1.img -x -m /dev/sda1 --ro /mnt

  guestunmount /mnt

  LOG_INFO "End to run test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  sudo umount ./CentOS-7-x86_64-Minimal-2009.img
  sudo umount /mnt
  rm -rf CentOS-7-x86_64-Minimal-2009.img.*
  DNF_INSTALL
  LOG_INFO "Finish to restore the test environment."
}

main $@
