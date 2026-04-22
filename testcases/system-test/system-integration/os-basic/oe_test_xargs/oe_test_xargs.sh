#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yangyuangan
# @Contact   :   yangyuangan@uniontech.com
# @Date      :   2023.8.7
# @License   :   Mulan PSL v2
# @Desc      :   Xargs formatting test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    touch test_xargs.txt
    chmod 777 test_xargs.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    res1=$(echo "test1Xtest2Xtest3" |xargs -d X)
    [ "$res1" == "test1 test2 test3" ]
    CHECK_RESULT $? 0 0 "xargs error"   
    find . -perm 777 -print0 |xargs -0 ls |grep 'test_xargs.txt'
    CHECK_RESULT $? 0 0 "xargs execution error" 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f test_xargs.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"
