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
    DNF_INSTALL gcc
    [[ ! -f ./rw_lseek_cur_file ]] && {
        make
    }
    echo "test" > test_lseek_cur_file
    ori_byte=$(ls -l test_lseek_cur_file | awk '{print $5}')
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo test_lseek_cur_file | ./rw_lseek_cur_file > test_byte_lseek_cur
    grep "offset = 1" test_byte_lseek_cur
    CHECK_RESULT $? 0 0 "The lseek offset is not 1."
    expect=$(($ori_byte-1))
    grep "readset = $expect" test_byte_lseek_cur
    CHECK_RESULT $? 0 0 "The read set is not $expect."
    cur_byte=$(ls -l test_lseek_cur_file | awk '{print $5}')
    actual=$(($cur_byte-$ori_byte))
    grep "writeset = $actual" test_byte_lseek_cur
    CHECK_RESULT $? 0 0 "The write set is not $actual."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f test_lseek_cur_file test_byte_lseek_cur
    make clean
    LOG_INFO "End to restore the test environment."
}

main "$@"

