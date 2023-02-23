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
#@Desc      	:   read file with clear page cache
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    dd if=/dev/zero of=testFile bs=512000000 count=10 oflag=direct
    cat testFile >/dev/null
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    start_time=$(date +%s)
    cat testFile > /dev/null
    end_time=$(date +%s)
    exec1=$(($end_time - $start_time))
    echo "First execution time is: "$exec1
    cache=$(free -m | grep Mem | awk '{print $6}')
    sync
    echo 1 >/proc/sys/vm/drop_caches
    rel=$(free -m | grep Mem | awk '{print $6}')
    start_time=$(date +%s)
    cat testFile > /dev/null
    end_time=$(date +%s)
    exec2=$(($end_time - $start_time))
    echo "First execution time is: "$exec2
    [[ $rel -lt cache ]]
    CHECK_RESULT $? 0 0 "The read speed is not faster when it has page cache."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f testFile
    LOG_INFO "End to restore the test environment."
}

main "$@"

