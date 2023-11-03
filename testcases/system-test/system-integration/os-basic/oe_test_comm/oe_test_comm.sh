#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   deepin12
# @Contact   :   chenyia@uniontech.com
# @Date      :   2023-4-12
# @License   :   Mulan PSL v2
# @Desc      :   Command test-comm 
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo 123 >test1
    CHECK_RESULT $? 0 0 "check create test1 fail"    
    echo aaa >>test1
    CHECK_RESULT $? 0 0 "check change test1 fail"    
    echo 123 >test2    
    CHECK_RESULT $? 0 0 "check create test2 fail"
    comm -12 test1 test2|grep 123    
    CHECK_RESULT $? 0 0  "failed to print the same line"
    comm -3 test1 test2|grep aaa
    CHECK_RESULT $? 0 0  "failed to output lines shared by two files"
    comm --total test1 test2|grep -w 1
    CHECK_RESULT $? 0 0  "description Failed to output the summary information"   
    comm --help|grep comm
    CHECK_RESULT $? 0 0  "check command fail"
    comm --version|grep Copyright
    CHECK_RESULT $? 0 0  "check command fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf test1 test2
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup!"
}

main "$@"


