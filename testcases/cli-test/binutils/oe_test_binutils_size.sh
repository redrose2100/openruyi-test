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
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2023/02/09
# @License   :   Mulan PSL v2
# @Desc      :   test binutils-size
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "binutils gcc gcc-c++"
    mkdir /tmp/test
    path=/tmp/test
    cat > ${path}/test.cpp <<EOF
#include<stdio.h>
int divide(int x, int y)
{
return x/y;
}
int main()
{
printf("hello world\n");
int x = 3;
int y = 0;
int div = divide(x, y);
printf("%d / %d = %d\n", x, y, div);
return 0;
}
EOF
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    g++ -Wl,-Map=${path}/test.map -g ${path}/test.cpp -o ${path}/testfile
    ls ${path} | grep -E "testfile|test.map"
    CHECK_RESULT $? 0 0 "Compilation failure"
    size ${path}/testfile |grep -E "hex|testfile" |grep "testfile"
    CHECK_RESULT $? 0 0 "command2 failure"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ${path}
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
