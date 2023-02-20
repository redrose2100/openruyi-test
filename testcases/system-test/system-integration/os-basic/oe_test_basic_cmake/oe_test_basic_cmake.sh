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
# @Date      :   2023-01-09
# @License   :   Mulan PSL v2
# @Desc      :   Test use cmake
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    mkdir test && cd test
    DNF_INSTALL cmake
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cmake --version
    CHECK_RESULT $? 0 0 "Error, please check 'cmake'"

    cat > main.c << EOF
#include <stdio.h>
int main(void)
{
printf("Hello World\n");
return 0;
}
EOF
    CHECK_RESULT $? 0 0 "Error, check mai.c"

    cat > CMakeLists.txt << EOF
# CMake 最低版本号要求
cmake_minimum_required (VERSION 2.8)
# 项目信息
project (demo)
# 指定生成目标
add_executable(main main.c)
EOF
    CHECK_RESULT $? 0 0 "Error, check CMakeLists.txt"
    cmake ./
    CHECK_RESULT $? 0 0 "Error, failed to run cmake"
    make
    CHECK_RESULT $? 0 0 "Error, failed to build main"
    ./main
    CHECK_RESULT $? 0 0 "Error, failed to run main.c"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    rm -rf main.c CMakeLists.txt
    DNF_REMOVE
    LOG_INFO "End to clean the test environment."
}
main "$@"