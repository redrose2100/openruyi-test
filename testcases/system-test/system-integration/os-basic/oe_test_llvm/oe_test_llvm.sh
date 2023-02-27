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
# @Date      :   2023-02-20
# @License   :   Mulan PSL v2
# @Desc      :   Test use llvm
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    mkdir test && cd test
    DNF_INSTALL "llvm clang"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    rpm -qa llvm clang
    CHECK_RESULT $? 0 0 "Error, please check 'llvm' or 'clang'"
    cat > llvm_test.c <<EOF
#include <stdio.h>
int main() {
printf("hello llvm\n");
return 0;
}
EOF
    CHECK_RESULT $? 0 0 "Error, fail to touch llvm_test.c"
    clang llvm_test.c -o test
    CHECK_RESULT $? 0 0 "Error, fail to touch 'test'"
    clang -O3 -emit-llvm llvm_test.c -c -o test.bc
    CHECK_RESULT $? 0 0 "Error, check test.bc"
    if [ "$(./test)" != "hello llvm" ];then
      CHECK_RESULT $? 0 0 "Error,fail to run test"
    fi
    if [ "$(lli test.bc)" != "hello llvm" ];then
      CHECK_RESULT $? 0 0 "Error, fail to run test.bc"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    cd - && rm -rf test/
    DNF_REMOVE
    LOG_INFO "End to clean the test environment."
}
main "$@"