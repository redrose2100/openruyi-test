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
#@Date      	:   2021-05-07
#@License   	:   Mulan PSL v2
#@Desc      	:   Sync file data
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    dd if=/dev/zero of=test_sync_file1 bs=51200000 count=1
    dirty1=$(grep Dirty /proc/meminfo | awk '{print $2}')
    sync
    dirty2=$(grep Dirty /proc/meminfo | awk '{print $2}')
    [[ $dirty1 -gt $dirty2 ]]
    CHECK_RESULT $? 0 0 "The page data doesn't sync by sync."
    dd if=/dev/zero of=test_sync_file2 bs=51200000 count=1
    dirty1=$(grep Dirty /proc/meminfo | awk '{print $2}')
    sync -d test_sync_file2
    dirty2=$(grep Dirty /proc/meminfo | awk '{print $2}')
    [[ $dirty1 -gt $dirty2 ]]
    CHECK_RESULT $? 0 0 "The page data doesn't sync by fdatasync."
    dd if=/dev/zero of=test_sync_file3 bs=51200000 count=1
    dirty1=$(grep Dirty /proc/meminfo | awk '{print $2}')
    sync test_sync_file3
    dirty2=$(grep Dirty /proc/meminfo | awk '{print $2}')
    [[ $dirty1 -gt $dirty2 ]]
    CHECK_RESULT $? 0 0 "The page data doesn't sync by fsync."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f test_sync_file1 test_sync_file2 test_sync_file3
    LOG_INFO "End to restore the test environment."
}

main "$@"

