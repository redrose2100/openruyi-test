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
#@Date      	:   2021-04-29
#@License   	:   Mulan PSL v2
#@Desc      	:   Check dirty page writeback when it is more than dirty_ratio
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    ori=$(sysctl vm.dirty_ratio | awk '{print $3}')
    sync
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    dd if=/dev/zero of=/tmp/test_dirty_page_file_1 bs=5120 count=100
    dirty1=$(grep Dirty /proc/meminfo | awk '{print $2}')
    sysctl vm.dirty_ratio=0
    SLEEP_WAIT 30
    dirty2=$(grep Dirty /proc/meminfo | awk '{print $2}')
    dd if=/dev/zero of=/tmp/test_dirty_page_file_2 bs=5120 count=100
    SLEEP_WAIT 30
    dirty3=$(grep Dirty /proc/meminfo | awk '{print $2}')
    SLEEP_WAIT 30
    [[ $dirty1 -ge $dirty2 && $dirty3 -le $dirty2 ]]
    CHECK_RESULT $? 0 0 "The dirty page doesn't writeback when its size more than dirty_ratio."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    sysctl vm.dirty_ratio=$ori
    rm -f /tmp/test_dirty_page_file*
    LOG_INFO "End to restore the test environment."
}

main "$@"

