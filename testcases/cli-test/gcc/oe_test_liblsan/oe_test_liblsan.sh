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
# @Date      :   2024/02/23
# @License   :   Mulan PSL v2
# @Desc      :   Basic functional verification of liblsan
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "liblsan* libubsan"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > test_liblsan.c <<EOF
#include <stdlib.h>

int main() {
    // 在堆上分配内存
    int* ptr = (int*)malloc(sizeof(int));

    // 不释放内存，模拟内存泄漏

    return 0;
}
EOF
    test -f test_liblsan.c
    CHECK_RESULT $? 0 0 " File generation failed"
    gcc -o test_liblsan test_liblsan.c -fsanitize=leak -lubsan
    test -f test_liblsan
    CHECK_RESULT $? 0 0 "File generation failed"
    ./test_liblsan
    CHECK_RESULT $? 0 1 "File generation failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf test_liblsan.c test_liblsan
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"