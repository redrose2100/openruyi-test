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
#@Date      	:   2021-06-04
#@License   	:   Mulan PSL v2
#@Desc      	:   raw raw with lvm
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    cur_date=$(date +%Y%m%d%H%M%S)
    vgname=$(CREATE_VG)
    CREATE_LV "lv"$cur_date $vgname
    lvname=$(lvdisplay | grep "lv"$cur_date | grep "LV Path" | awk '{print $3}')
    raw_name="/dev/raw/raw1"
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    raw $raw_name $lvname
    CHECK_RESULT $? 0 0 "Create $raw_name failed."
    blockdev --report $raw_name
    CHECK_RESULT $? 0 0 "Check report for $raw_name failed."
    raw -qa | grep $raw_name
    CHECK_RESULT $? 0 0 "Check $raw_name failed."
    dd if=/dev/zero of=$raw_name bs=5120 count=10
    CHECK_RESULT $? 0 0 "Write to $raw_name failed."
    dd if=$raw_name of=/mnt/testfile_raw_lvm bs=5120 count=10
    CHECK_RESULT $? 0 0 "Read $raw_name failed."
    raw $raw_name 0 0
    CHECK_RESULT $? 0 0 "Delete $raw_name failed."
    raw -qa | grep $raw_name
    CHECK_RESULT $? 1 0 "Check $raw_name exist unexpectly."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    vgremove $vgname -y
    rm -f /mnt/testfile_raw_lvm
    LOG_INFO "End to restore the test environment."
}

main "$@"

