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
# @Date      :   2024-08-14
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
    echo "define fib(n) { if (n <= 1) return n; return fib(n-1) + fib(n-2) }; fib(10)" | bc | grep "55"
    CHECK_RESULT $? 0 0 "Fibonacci sequence calculation failed"
    echo "define gcd(a, b) { if (b == 0) return a; return gcd(b, a % b) }; gcd(48, 18)" | bc | grep "6"
    CHECK_RESULT $? 0 0 "GCD calculation failed"
    echo "scale=10; 4*a(1)" | bc -l | grep "3.1415926532"
    CHECK_RESULT $? 0 0 "Pi calculation failed"
    echo "define c_to_f(c) { return (c * 9 / 5) + 32 }; c_to_f(100)" | bc | grep "212"
    CHECK_RESULT $? 0 0 "Celsius to Fahrenheit conversion failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"