#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/07/27
# @License   :   Mulan PSL v2
# @Desc      :   Test SDL2 package installation
# ############################################

# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "SDL2 SDL2-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test if package is installed
    rpm -q SDL2
    CHECK_RESULT $? 0 0 "SDL2 package not installed"
    # Test if development package is installed
    rpm -q SDL2-devel
    CHECK_RESULT $? 0 0 "SDL2-devel package not installed"
    # Test version check
    rpm -q SDL2 --qf "%{VERSION}\n"
    CHECK_RESULT $? 0 0 "SDL2 version check failed"
    # Test if library file exists
    [ -f "/usr/lib64/libSDL2-2.0.so.0" ] || [ -f "/usr/lib/libSDL2-2.0.so.0" ]
    CHECK_RESULT $? 0 0 "SDL2 library file not found"
    # Test if header files exist
    [ -f "/usr/include/SDL2/SDL.h" ]
    CHECK_RESULT $? 0 0 "SDL.h header not found"
	# Verify header file content
    grep -r "SDL_Init" /usr/include/SDL2/
    CHECK_RESULT $? 0 0 "SDL_Init not found in SDL headers"
    grep -r "SDL_CreateWindow" /usr/include/SDL2/
    CHECK_RESULT $? 0 0 "SDL_CreateWindow not found in SDL headers"
    grep -r "SDL_CreateRenderer" /usr/include/SDL2/
    CHECK_RESULT $? 0 0 "SDL_CreateRenderer not found in SDL headers"
    grep -r "SDL_OpenAudio" /usr/include/SDL2/
    CHECK_RESULT $? 0 0 "SDL_OpenAudio not found in SDL headers"
    # Verify pkg-config compile options
    pkg-config --cflags sdl2 | grep "SDL2"
    CHECK_RESULT $? 0 0 "pkg-config cflags does not contain SDL2"
    pkg-config --libs sdl2 | grep "SDL2"
    CHECK_RESULT $? 0 0 "pkg-config libs does not contain SDL2"
    pkg-config --exists sdl2
    CHECK_RESULT $? 0 0 "SDL2 pkg-config not found"
    pkg-config --modversion sdl2 | grep "$(rpm -q SDL2 | awk -F '-' '{print $2}')"
    CHECK_RESULT $? 0 0 "SDL2 pkg-config version check failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"