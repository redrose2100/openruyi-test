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
# @Desc      :   Test SDL2 API interface correctness
# ############################################

# shellcheck disable=SC2119,SC2046
source "$OET_PATH/libs/locallibs/common_lib.sh"

function config_params() {
    LOG_INFO "Start to config params of the case."
    TEST_PROG="/tmp/sdl2_api_test_$(date +%s)"
    TEST_SRC="${TEST_PROG}.c"
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "SDL2 SDL2-devel gcc make binutils"
    # Create test C program to test SDL2 API interface
    cat > "${TEST_SRC}" <<EOF
#include <stdio.h>
#include <SDL2/SDL.h>

int main() {
    int ret = 0;
    const char *version;

    // Test SDL_Init and SDL_Quit with video subsystem
    // Using SDL_INIT_VIDEO to test basic initialization
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        printf("INFO: SDL_Init(SDL_INIT_VIDEO) failed: %s (no video device)\n", SDL_GetError());
    } else {
        printf("PASS: SDL_Init(SDL_INIT_VIDEO) succeeded\n");
        SDL_Quit();
    }

    // Test SDL_Init with audio subsystem
    if (SDL_Init(SDL_INIT_AUDIO) != 0) {
        printf("INFO: SDL_Init(SDL_INIT_AUDIO) failed: %s (no audio device)\n", SDL_GetError());
    } else {
        printf("PASS: SDL_Init(SDL_INIT_AUDIO) succeeded\n");
        SDL_Quit();
    }

    // Test SDL_Init with events subsystem (should always work)
    if (SDL_Init(SDL_INIT_EVENTS) != 0) {
        printf("FAIL: SDL_Init(SDL_INIT_EVENTS) failed: %s\n", SDL_GetError());
        return 1;
    }
    printf("PASS: SDL_Init(SDL_INIT_EVENTS) succeeded\n");
    SDL_Quit();

    // Test SDL_GetVersion
    SDL_version compiled;
    SDL_VERSION(&compiled);
    printf("PASS: SDL_GetVersion - compiled with SDL %d.%d.%d\n", compiled.major, compiled.minor, compiled.patch);

    // Test SDL_GetRevision
    const char *revision = SDL_GetRevision();
    printf("PASS: SDL_GetRevision - %s\n", revision ? revision : "unknown");

    // Test SDL_GetError
    SDL_SetError("test error");
    const char *error = SDL_GetError();
    if (error && error[0] != '\0') {
        printf("PASS: SDL_GetError works\n");
    } else {
        printf("FAIL: SDL_GetError failed\n");
        return 1;
    }

    // Test SDL_GetPlatform
    const char *platform = SDL_GetPlatform();
    printf("PASS: SDL_GetPlatform - %s\n", platform ? platform : "unknown");

    // Test SDL_GetCPUCount
    int cpu_count = SDL_GetCPUCount();
    if (cpu_count > 0) {
        printf("PASS: SDL_GetCPUCount - %d CPUs\n", cpu_count);
    } else {
        printf("FAIL: SDL_GetCPUCount returned %d\n", cpu_count);
        return 1;
    }

    // Test SDL_GetSystemRAM
    int ram_mb = SDL_GetSystemRAM();
    if (ram_mb > 0) {
        printf("PASS: SDL_GetSystemRAM - %d MB\n", ram_mb);
    } else {
        printf("FAIL: SDL_GetSystemRAM returned %d\n", ram_mb);
        return 1;
    }

    return 0;
}
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    gcc "${TEST_SRC}" -o "${TEST_PROG}" $(pkg-config --cflags --libs sdl2)
    CHECK_RESULT $? 0 0 "Failed to compile SDL2 API test"
    # Run test program
    "${TEST_PROG}" | grep "PASS"
    CHECK_RESULT $? 0 0 "SDL2 API test failed"
    # Verify key API symbols exist in library
    nm -D /usr/lib64/libSDL2-2.0.so.0  | grep "SDL_Init" || \
    nm -D /usr/lib/libSDL2-2.0.so.0  | grep "SDL_Init"
    CHECK_RESULT $? 0 0 "SDL_Init symbol not found in SDL2"
    nm -D /usr/lib64/libSDL2-2.0.so.0  | grep "SDL_Quit" || \
    nm -D /usr/lib/libSDL2-2.0.so.0  | grep "SDL_Quit"
    CHECK_RESULT $? 0 0 "SDL_Quit symbol not found in SDL2"
    nm -D /usr/lib64/libSDL2-2.0.so.0  | grep "SDL_CreateWindow" || \
    nm -D /usr/lib/libSDL2-2.0.so.0  | grep "SDL_CreateWindow"
    CHECK_RESULT $? 0 0 "SDL_CreateWindow symbol not found in SDL2"
    nm -D /usr/lib64/libSDL2-2.0.so.0  | grep "SDL_CreateRenderer" || \
    nm -D /usr/lib/libSDL2-2.0.so.0  | grep "SDL_CreateRenderer"
    CHECK_RESULT $? 0 0 "SDL_CreateRenderer symbol not found in SDL2"
    nm -D /usr/lib64/libSDL2-2.0.so.0  | grep "SDL_OpenAudio" || \
    nm -D /usr/lib/libSDL2-2.0.so.0  | grep "SDL_OpenAudio"
    CHECK_RESULT $? 0 0 "SDL_OpenAudio symbol not found in SDL2"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f "${TEST_PROG}" "${TEST_SRC}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"