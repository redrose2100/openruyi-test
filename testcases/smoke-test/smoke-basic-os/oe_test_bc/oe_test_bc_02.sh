#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   lihuan
# @Contact   :   lihuan@uniontech.com
# @Date      :   2024-07-19
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-top
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL bc
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo "sqrt(16)" | bc | grep "4"
    CHECK_RESULT $? 0 0 "Square root calculation failed"
    echo "if (5 > 3) 1 else 0" | bc | grep "1"
    CHECK_RESULT $? 0 0 "Conditional statement failed"
    echo "define f(x) { return x*x }; f(4)" | bc | grep "16"
    CHECK_RESULT $? 0 0 "Function definition and call failed"
    echo "1 && 0" | bc | grep "0"
    CHECK_RESULT $? 0 0 "Logical AND operation failed"
    echo "1 || 0" | bc | grep "1"
    CHECK_RESULT $? 0 0 "Logical OR operation failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
