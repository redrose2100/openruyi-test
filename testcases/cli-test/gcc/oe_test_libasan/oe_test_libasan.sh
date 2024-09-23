#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2024/01/12
# @License   :   Mulan PSL v2
# @Desc      :   Basic functionality verification of libasan
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libasan gcc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat >  test_asan.c << EOF
#include <stdio.h>
#include <stdlib.h>
int main() {
int* array = malloc(sizeof(int) * 5);
// 内存错误：写入超出分配的内存范围
array[5] = 10;
free(array);
return 0;
}
EOF
    test -f test_asan.c
    CHECK_RESULT $? 0 0 "File generation failed"
     gcc -o test_asan test_asan.c -fsanitize=address
    test -f test_asan
    CHECK_RESULT $? 0 0 "File generation failed"
    ./test_asan > a.log 2>&1
    grep -i summary a.log
    CHECK_RESULT $? 0 0 "Execution failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf test_asan test_asan.c a.log
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
