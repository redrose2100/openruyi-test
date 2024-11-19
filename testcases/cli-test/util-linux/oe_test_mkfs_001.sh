#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   sunqingwei
#@Contact       :   sunqingwei@uniontech.com
#@Date          :   2023-8-30
#@License       :   Mulan PSL v2
#@Desc          :   Supports multiple formats of partition management
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
  LOG_INFO "Start to prepare the test environment."
  dd if=/dev/zero of=/home/testzone count=30 bs=10M
  losetup /dev/loop0 /home/testzone
  CHECK_RESULT $? 0 0 "log message: Failed install minimap2 "
}

function run_test() {
  LOG_INFO "Start to run test."
  mkfs_list=("ext2" "ext3" "ext4" "fat" "msdos" "vfat" "xfs")
  for format in "${mkfs_list[@]}"; do
    # 检查当前水果是否是"banana"
    if [ "$format" == "ext2" ] || [ "$format" == "ext3" ] || [ "$format" == "ext4" ]; then
      mkfs."$format" -F /dev/loop0
    elif [ "$format" == "xfs" ]; then
      mkfs."$format" -f /dev/loop0
    else
      mkfs."$format" /dev/loop0
    fi
    CHECK_RESULT $? 0 0 "formatting fail"
    mount /dev/loop0 /mnt
    CHECK_RESULT $? 0 0 "mount fail"
    echo test >/mnt/testfile
    grep test /mnt/testfile
    CHECK_RESULT $? 0 0 "test fail"
    rm -rf /mnt/testfile
    umount /mnt
    CHECK_RESULT $? 0 0 "umount fail"
  done
  LOG_INFO "End to run test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  losetup -d /dev/loop0
  rm -rf /home/testzone
  LOG_INFO "End to restore the test environment."
}

main "$@"
