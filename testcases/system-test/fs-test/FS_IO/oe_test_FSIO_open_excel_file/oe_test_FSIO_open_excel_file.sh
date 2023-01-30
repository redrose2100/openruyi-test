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
#@Desc      	:   open file by O_RDWR | O_CREAT | O_EXCL
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    [[ ! -f ./open_excl_file ]] && {
        make
    }
    ori_umask=$(umask)
    umask 0022
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo test_rw_file | ./open_excl_file
    CHECK_RESULT $? 0 0 "Read or write file failed while set O_EXCL."
    ls -l test_rw_file | awk '{print $0}' | grep "\-r\-\-r\-\-r\-\-"
    CHECK_RESULT $? 0 0 "The access of file is error."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f test_rw_file
    make clean
    umask $ori_umask
    LOG_INFO "End to restore the test environment."
}

main "$@"

