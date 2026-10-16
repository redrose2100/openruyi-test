#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2024/03/07
# @License   :   Mulan PSL v2
# @Desc      :   Basic functional verification of libuv
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libuv libuv-devel libuv-help gcc-c++"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > test.cpp <<EOF
#include <uv.h>
#include <iostream>

uv_loop_t *loop;
void timer_callback(uv_timer_t *handle) {
    std::cout << "Timer triggered!" << std::endl;
    uv_stop(loop);
}

int main() {
    loop = uv_default_loop();
    uv_timer_t timer;
    uv_timer_init(loop, &timer);
    uv_timer_start(&timer, timer_callback, 0, 2000);

    std::cout << "Timer started. Waiting for timer to trigger..." << std::endl;

    uv_run(loop, UV_RUN_DEFAULT);

    uv_loop_close(loop);
    return 0;
}
EOF
    test -f test.cpp
    CHECK_RESULT $? 0 0 " File generation failed"
    g++ test.cpp -o test -luv
    test -f test
    CHECK_RESULT $? 0 0 " File generation failed"
    ./test
    CHECK_RESULT $? 0 0 "Execution failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf test.cpp test
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"