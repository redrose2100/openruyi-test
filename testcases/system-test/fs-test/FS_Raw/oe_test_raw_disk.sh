#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   @meitingli
#@Contact   	:   bubble_mt@outlook.com
#@Date      	:   2021-06-02
#@License   	:   Mulan PSL v2
#@Desc      	:   raw raw with disk
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to prepare the database config."
    free_disk=$(lsblk | grep disk | awk '{print $1}' | tail -n 1)
    disk_name="/dev/"$free_disk
    name="/dev/raw/raw1"
    LOG_INFO "Finish to prepare the database config."
}

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    fdisk ${disk_name} << diskEof
n
p
1

100000
w
diskEof
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    raw $name ${disk_name}1  
    CHECK_RESULT $? 0 0 "Create $name failed."
    blockdev --report $name
    CHECK_RESULT $? 0 0 "Check report for $name failed."
    raw -qa | grep $name
    CHECK_RESULT $? 0 0 "Check $name failed."
    dd if=/dev/zero of=$name bs=5120 count=10
    CHECK_RESULT $? 0 0 "Write to $name failed."
    dd if=$name of=/mnt/testfile_raw_disk bs=5120 count=10
    CHECK_RESULT $? 0 0 "Read $name failed."
    raw $name 0 0
    CHECK_RESULT $? 0 0 "Delete $name failed."
    raw -qa | grep $name
    CHECK_RESULT $? 1 0 "Check $name exist unexpectly."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f /mnt/testfile_raw_disk
    fdisk ${disk_name} << diskEof
d

w
diskEof
    LOG_INFO "End to restore the test environment."
}

main "$@"

