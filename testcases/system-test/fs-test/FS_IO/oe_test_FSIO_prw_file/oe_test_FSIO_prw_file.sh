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
#@Date      	:   2021-04-25
#@License   	:   Mulan PSL v2
#@Desc      	:   open file and set lseek=SEEK_CUR
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    [[ ! -f ./prw_file ]] && {
        make
    }
    echo "test" > test_prw_file
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo a | sleep 5 | ./prw_file > test_prw_log
    r_count=$(grep "r_thread: 0" test_prw_log | wc -l)
    w_count=$(grep "w_thread: 0" test_prw_log | wc -l)
    [[ $r_count -eq 1 && $w_count -eq 1 ]]
    CHECK_RESULT $? 0 0 "pread or pwrite file failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f test_prw_file test_prw_log
    make clean
    LOG_INFO "End to restore the test environment."
}

main "$@"

