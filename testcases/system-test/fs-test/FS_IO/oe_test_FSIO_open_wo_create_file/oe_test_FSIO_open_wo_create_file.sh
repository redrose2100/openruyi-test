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
#@Desc      	:   open file by O_WRONLY | O_CREAT
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    [[ ! -f ./open_wo_file ]] && {
        make
    }
    ori_umask=$(umask)
    umask 002
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo test_wo_file | ./open_wo_file
    CHECK_RESULT $? 0 0 "Write file failed while open file by write only."
    grep test_wo_file test_wo_file
    CHECK_RESULT $? 0 0 "The value is not written to file."
    ls -l test_wo_file | awk '{print $0}' | grep "\-rwxrwxr\-x"
    CHECK_RESULT $? 0 0 "The access of file is error."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f test_wo_file
    make clean
    umask $ori_umask
    LOG_INFO "End to restore the test environment."
}

main "$@"

