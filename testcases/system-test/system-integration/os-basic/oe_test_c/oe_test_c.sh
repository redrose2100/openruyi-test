#! /usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiechangyan1
# @Contact   :   xiechangyan@uniontech.com
# @Date      :   2023-05-09
# @License   :   Mulan PSL v2
# @Desc      :   Test C use
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    pwd=`pwd`
    mkdir test && cd test
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
cat > test.c << EOF
#include <stdio.h>
int main(void)
{
printf("Hello C!\n");
}
EOF
    CHECK_RESULT $? 0 0 "Fail to create test.c"
    gcc -o test test.c
    CHECK_RESULT $? 0 0 "Fail to create test file"
    gcc -S -o test.s test.c
    CHECK_RESULT $? 0 0 "Fail to create test.s"
    gcc -c -o test.o test.s
    CHECK_RESULT $? 0 0 "Fail to create test.o"
    file test.o | grep "relocatable"
    CHECK_RESULT $? 0 0 "test.o is not relocatable"
    ./test | grep "Hello C!"
    CHECK_RESULT $? 0 0 "Check test file content"
    rm -fr test test.o test.s
    CHECK_RESULT $? 0 0 "Fail to delete test"
    gcc -c -o test.o test.c
    CHECK_RESULT $? 0 0 "Fail to create test.o"
    gcc -o test test.o
    CHECK_RESULT $? 0 0 "Fail to create test"
    file test | grep "executable"
    CHECK_RESULT $? 0 0 "test is not executable"
    ./test | grep "Hello C!"
    CHECK_RESULT $? 0 0 "Check the file"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    cd $pwd && rm -rf test/
    LOG_INFO "End to clean the test environment."
}

main "$@"