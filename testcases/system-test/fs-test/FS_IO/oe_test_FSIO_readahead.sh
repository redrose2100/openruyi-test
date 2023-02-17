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
#@Author    	:   @meitingli
#@Contact   	:   bubble_mt@outlook.com
#@Date      	:   2021-04-28
#@License   	:   Mulan PSL v2
#@Desc      	:   set readahead to read file
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    device=$(df -hT `pwd` | awk '{print $1}' | tail -n 1)
    orira=$(blockdev --getra $device)
    dd if=/dev/zero of=testFile bs=5120000000 count=1 oflag=direct
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    blockdev --setra 0 $device
    start_time=$(date +%s)
    cat testFile >/dev/null
    end_time=$(date +%s)
    close_ra=$(($end_time - $start_time))
    echo "First execution time is: "$close_ra
    blockdev --setra 5120000000 $device
    start_time=$(date +%s)
    cat testFile >/dev/null
    end_time=$(date +%s)
    open_ra=$(($end_time - $start_time))
    echo "Second execution time is: "$open_ra
    [[ $close_ra -ge $open_ra ]]
    CHECK_RESULT $? 0 0 "Read file faster when close readahead."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f testFile
    blockdev --setra $orira $device
    LOG_INFO "End to restore the test environment."
}

main "$@"

