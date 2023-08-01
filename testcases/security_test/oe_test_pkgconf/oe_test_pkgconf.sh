#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2023-8-1
# @License   :   Mulan PSL v2
# @Desc      :   Use pkgconf case
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
      DNF_INSTALL "pkgconf-devel pkgconf-help xz-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    pkg-config --list-all
    CHECK_RESULT $? 0 0 "Error,Please reinstall pkg-config"
    cat > /tmp/test.cpp << EOF
#include "lzma.h"
#include <iostream>

int main(int argc, char** argv)
{
    const char* version = lzma_version_string();
    std::cout << "lzma version is: " << version << std::endl;
    return 0;
}
EOF
    CHECK_RESULT $? 0 0 "Error,Please check the file 'test.cpp'"
    g++ -o /tmp/test /tmp/test.cpp "$(pkg-config --cflags --libs liblzma)"
    CHECK_RESULT $? 0 0 "Error,Please check the file 'test'"
    /tmp/test > /tmp/log 2 >& 1
    grep lzma /tmp/log
    CHECK_RESULT $? 0 0 "Error,Please check lzma version"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm /tmp/*test* /tmp/log
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"