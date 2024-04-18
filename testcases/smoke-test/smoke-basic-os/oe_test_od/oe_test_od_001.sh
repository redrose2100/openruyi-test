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
# @Date      :   2024-03-13
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-top
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    echo "hello world" > ./testfile
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    # 测试输出十六进制格式
    od -t x1 ./testfile | grep "68 65 6c 6c 6f 20 77 6f 72 6c 64 0a"
    CHECK_RESULT $? 0 0 "run od -t x1 failed"

    # 测试输出八进制格式
    od -t o1 ./testfile | grep "150 145 154 154 157 040 167 157 162 154 144 012"
    CHECK_RESULT $? 0 0 "run od -t o1 failed"

    # 测试输出十进制格式
    od -An -t d1 ./testfile | grep "104  101  108  108  111   32  119  111  114  108  100   10"
    CHECK_RESULT $? 0 0 "run od -t d1 failed"

    # 测试输出指定长度的字节数
    od -An -N 6 -c ./testfile | grep "h   e   l   l   o"
    CHECK_RESULT $? 0 0 "run od -N 6 -c failed"

    # 测试跳过指定字节数后的输出
    od -j 2 -c ./testfile | grep "l   l   o       w   o   r   l   d"
    CHECK_RESULT $? 0 0 "run od -j 2 -c failed"

    # 测试输出不同字节顺序
    od -An -t d2 -s ./testfile | grep "25960  27756   8303  28535  27762   2660"
    CHECK_RESULT $? 0 0 "run od -t d2 -s failed"

    od -v -t f4 ./testfile | grep "0000000   1.1431415e+27   7.6482007e+28   1.0998197e-32   0000014"
    CHECK_RESULT $? 0 0 "run od -v -t f4 failed"

    od --help | grep "--help"
    CHECK_RESULT $? 0 0 "--help fail"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f ./testfile
    LOG_INFO "End to restore the test environment."
}

main "$@"
