#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   zhengwei
# @Contact   :   zhengwei@uniontech.com
# @Date      :   2026/04/29
# @License   :   Mulan PSL v2
# @Desc      :   Test xz -k option to keep original file after compression
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL xz
    echo "test content for keep original file functionality" > test_keep
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    xz -k test_keep
    CHECK_RESULT $? 0 0 "xz -k option failed to execute"
    
    test -f test_keep
    CHECK_RESULT $? 0 0 "Original file was not preserved after xz -k"
    
    test -f test_keep.xz
    CHECK_RESULT $? 0 0 "Compressed file was not created by xz -k"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=${OLD_LANG}
    DNF_REMOVE "$@"
    rm -f test_keep test_keep.xz
    LOG_INFO "End to restore the test environment."
}

main "$@"
