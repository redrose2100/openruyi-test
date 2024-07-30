#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023/03/31
# @License   :   Mulan PSL v2
# @Desc      :   test cmd chrpath
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gcc chrpath"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > test.c <<-EOF
#include<stdio.h>

int main(int argc,char** argv)
{
        printf("hello world\n");
        return 0;
}
EOF
    CHECK_RESULT $? 0 0 "File creation failed"
    gcc -o test test.c -Wl,-rpath=/usr/lib64
    CHECK_RESULT $? 0 0 "File compilation failed"
    chrpath -l test | grep 'RPATH=/usr/lib64'
    CHECK_RESULT $? 0 0 "Incorrect runpath"
    chrpath -r "/usr/lib" test
    chrpath -l test | grep 'RPATH=/usr/lib'
    CHECK_RESULT $? 0 0 "Failed to change search path"
    chrpath -c test | grep "RUNPATH=/usr/lib"
    CHECK_RESULT $? 0 0 "path conversion failed"
    ldd test | grep 'lib64'
    CHECK_RESULT $? 0 0 "Dependency path conversion failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf test.c test
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"

