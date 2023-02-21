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
#@Desc      	:   Copy file by splice
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    [[ ! -f ./splice_file ]] && {
        make
    }
    echo "test splice file" > test_ori_file
    file_byte=$(ls -l test_ori_file | awk '{print $5}')
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    ./splice_file test_ori_file test_splice_file
    CHECK_RESULT $? 0 0 "Splce file failed."
    grep "test splice file" test_splice_file
    CHECK_RESULT $? 0 0 "The splice file infos are error."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f test_ori_file test_splice_file
    make clean
    LOG_INFO "End to restore the test environment."
}

main "$@"

