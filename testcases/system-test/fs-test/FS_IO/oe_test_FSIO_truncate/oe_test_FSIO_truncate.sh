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
#@Date      	:   2021-05-07
#@License   	:   Mulan PSL v2
#@Desc      	:   Truncate file by truncate/ftruncate
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    [[ ! -f ./truncate_file || ! -f ftruncate_file ]] && {
        make
    }
    dd if=/dev/zero of=test_truncate bs=5120 count=1000
    dd if=/dev/zero of=test_ftruncate bs=5120 count=1000
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo test_truncate | ./truncate_file
    CHECK_RESULT $? 0 0 "Truncate file failed by truncate."
    echo test_ftruncate | ./ftruncate_file
    CHECK_RESULT $? 0 0 "Truncate file failed by truncate."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f test_truncate test_ftruncate
    make clean
    LOG_INFO "End to restore the test environment."
}

main "$@"

