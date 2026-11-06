#!/usr/bin/bash

# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   cherry530
# @Contact   :   707078654@qq.com
# @Date      :   2026/07/09
# @License   :   Mulan PSL v2
# @Desc      :   Test libev core watcher functionality (timer, io, signal)
# #############################################
# shellcheck disable=SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh
source "${OET_PATH}"/testcases/function-test/pkgs-test/libev/common/libev_common.sh

LIBEV_COMMON="${OET_PATH}"/testcases/function-test/pkgs-test/libev/common

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libev libev-devel gcc"
    mkdir -p /tmp/libev_test
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /tmp/libev_test || exit 1

    # Compile and test the timer watcher
    libev_compile "${LIBEV_COMMON}"/timer_test.c /tmp/libev_test/timer_test
    libev_run /tmp/libev_test/timer_test /tmp/libev_test/timer_out.txt
    grep "timer fired" /tmp/libev_test/timer_out.txt
    CHECK_RESULT $? 0 0 "timer watcher did not fire"
    grep "timer loop ended" /tmp/libev_test/timer_out.txt
    CHECK_RESULT $? 0 0 "timer watcher loop did not end normally"

    # Compile and test the IO watcher
    libev_compile "${LIBEV_COMMON}"/io_test.c /tmp/libev_test/io_test
    libev_run /tmp/libev_test/io_test /tmp/libev_test/io_out.txt
    grep "io read: hello" /tmp/libev_test/io_out.txt
    CHECK_RESULT $? 0 0 "io watcher did not read the expected data"
    grep "io watcher done" /tmp/libev_test/io_out.txt
    CHECK_RESULT $? 0 0 "io watcher loop did not end normally"

    # Compile and test the signal watcher
    libev_compile "${LIBEV_COMMON}"/signal_test.c /tmp/libev_test/signal_test
    libev_run /tmp/libev_test/signal_test /tmp/libev_test/signal_out.txt
    grep "signal received" /tmp/libev_test/signal_out.txt
    CHECK_RESULT $? 0 0 "signal watcher did not catch SIGUSR1"
    grep "signal watcher done" /tmp/libev_test/signal_out.txt
    CHECK_RESULT $? 0 0 "signal watcher loop did not end normally"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/libev_test
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
