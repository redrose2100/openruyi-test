#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   geyaning
#@Contact   	:   geyaning@uniontech.com
#@Date      	:   2023-04-18
#@License     	:   Mulan PSL v2
#@Desc      	:   clang function verification
#####################################
source ${OET_PATH}/libs/locallibs/common_lib.sh


function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL clang
    mkdir /tmp/test
    Directory=/tmp/test
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    cd $Directory
    cat > hello.c << EOF
#include <stdio.h>
int main()
{
printf("hello\n");
return 0;
}
EOF
    CHECK_RESULT $? 0 0 "C file addition failure"
    clang hello.c
    test -e a.out
    CHECK_RESULT $? 0 0 "a.out is not generated"
    ./a.out | grep "hello"
    CHECK_RESULT $? 0 0 "a.out execution failed"
    clang hello.c -o hello
    test -e hello
    CHECK_RESULT $? 0 0 "hello is not generated"
    clang -E hello.c -o hello.i
    test -e hello.i
    CHECK_RESULT $? 0 0 "hello.i is not generated"
    clang -S hello.i -o hello.s
    test -e hello.s
    CHECK_RESULT $? 0 0 "hello.s is not generated"
    clang -c hello.s -o hello.o
    test -e hello.o
    CHECK_RESULT $? 0 0 "hello.o is not generated"
    clang hello.o -o test
    ./test | grep "hello"
    CHECK_RESULT $? 0 0 "test is not generated or a.out execution failed"
    clang -O1 hello.c -o hello1
    test -e hello1
    CHECK_RESULT $? 0 0 "hello1 is not generated"
    ./hello1 | grep hello
    CHECK_RESULT $? 0 0 "hello1 execution failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf /opt/test
    LOG_INFO "End to restore the test environment."
}
main "$@"
