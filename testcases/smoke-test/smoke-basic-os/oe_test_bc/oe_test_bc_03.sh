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
# @Date      :   2024-07-31
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
    echo "define f(x) { return x^3 + 2*x^2 + 3*x + 4 }; f(2)" | bc | grep "26"
    CHECK_RESULT $? 0 0 "Polynomial calculation failed"
    echo "define fact(n) { if (n <= 1) return 1; return n*fact(n-1) }; fact(5)/fact(2)" | bc | grep "60"
    CHECK_RESULT $? 0 0 "Permutation calculation failed"
    echo "define fact(n) { if (n <= 1) return 1; return n*fact(n-1) }; fact(5)/(fact(3)*fact(2))" | bc | grep "10"
    CHECK_RESULT $? 0 0 "Combination calculation failed"
    echo "12345678901234567890 + 98765432109876543210" | bc | grep "111111111011111111100"
    CHECK_RESULT $? 0 0 "Large number addition failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"