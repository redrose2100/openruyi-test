#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2025/06/25
# @License   :   Mulan PSL v2
# @Desc      :   test  sdl-config
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL SDL-devel
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    sdl-config --version | grep 2
    CHECK_RESULT $? 0 0 "Display incorrect SDL version currently installed"
    sdl-config --cflags |grep SDL
    CHECK_RESULT $? 0 0 "The compiler flags required for compiling SDL programs are incorrect"
    sdl-config --libs |grep SDL
    CHECK_RESULT $? 0 0 "The compiler flags required for compiling SDL programs are incorrect"
    sdl-config --static-libs | grep SDL
    CHECK_RESULT $? 0 0 "The compiler flags required for compiling SDL programs are incorrect"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to clean the test environment."
}

main "$@"
