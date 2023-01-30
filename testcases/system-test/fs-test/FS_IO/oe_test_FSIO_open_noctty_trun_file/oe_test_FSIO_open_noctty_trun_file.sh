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
#@Date      	:   2021-04-23
#@License   	:   Mulan PSL v2
#@Desc      	:   open file by O_RDWR | O_TRUNC | O_NOCTTY
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    [[ ! -f ./open_notty_trun_file ]] && {
        make
    }
    echo "test read only file" > test_notty_trun_file
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo test_notty_trun_file | ./open_notty_trun_file
    CHECK_RESULT $? 0 0 "Read or write file failed while open file by O_NOCTTY|O_TRUNC."
    grep "test read only file" test_notty_trun_file
    CHECK_RESULT $? 1 0 "The orginal message on file doesn't be cleared."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f test_notty_trun_file
    make clean
    LOG_INFO "End to restore the test environment."
}

main "$@"

