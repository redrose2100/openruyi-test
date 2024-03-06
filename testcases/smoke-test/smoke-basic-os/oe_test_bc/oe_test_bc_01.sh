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
# @Date      :   2024-02-29
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
    # 测试数学函数：计算自然对数的底 e 的值
    echo "l(1)" | bc -l | grep "0"
    CHECK_RESULT $? 0 0 "Natural logarithm calculation failed"

    # 测试变量赋值和使用
    echo "a = 5; b = 3; a + b" | bc | grep "8"
    CHECK_RESULT $? 0 0 "Variable assignment and usage failed"

    # 测试输出格式控制：设置输出的小数位数
    echo "scale=4; 3/2" | bc | grep "1.5000"
    CHECK_RESULT $? 0 0 "Output format control failed"

    # 测试特殊情况：除数为零
    echo "1/0" | bc 2>&1 | grep "Divide by zero"
    CHECK_RESULT $? 0 0 "Division by zero failed"

    # 测试复杂表达式：带有括号的表达式
    echo "(5 + 3) * 2" | bc | grep "16"
    CHECK_RESULT $? 0 0 "Complex expression with parentheses failed"

    # 测试高精度计算：处理超过整数范围的大数字
    echo "2^100" | bc | grep "1267650600228229401496703205376"
    CHECK_RESULT $? 0 0 "High precision calculation failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
