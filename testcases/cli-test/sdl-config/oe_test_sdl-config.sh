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
    cat > /tmp/test_sdl.c << EOF
#include <SDL/SDL.h>
int main() {
    SDL_Init(0);
    SDL_Quit();
    return 0;
}
EOF
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
    sdl-config --prefix | grep -q "/usr"
    CHECK_RESULT $? 0 0 "SDL prefix path is invalid"
    sdl-config --exec-prefix | grep -q "/usr"
    CHECK_RESULT $? 0 0 "SDL exec-prefix path is invalid"
    sdl-config --help 2>&1 | grep -q -i "usage"
    CHECK_RESULT $? 0 0 "Help message missing"
    gcc $(sdl-config --cflags) -c /tmp/test_sdl.c -o /tmp/test_sdl.o 2>/dev/null
    CHECK_RESULT $? 0 0 "SDL compile combination failed"
    gcc /tmp/test_sdl.o $(sdl-config --libs) -o /tmp/test_sdl 2>/dev/null
    CHECK_RESULT $? 0 0 "SDL link combination failed"
    gcc /tmp/test_sdl.o $(sdl-config --static-libs) -o /tmp/test_sdl_static 2>/dev/null
    CHECK_RESULT $? 0 0 "SDL static link combination failed"
    /tmp/test_sdl > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "SDL program execution failed"    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    DNF_REMOVE "$@"
    rm -f /tmp/test_sdl.c /tmp/test_sdl.o /tmp/test_sdl /tmp/test_sdl_static
    LOG_INFO "End to clean the test environment."
}

main "$@"
