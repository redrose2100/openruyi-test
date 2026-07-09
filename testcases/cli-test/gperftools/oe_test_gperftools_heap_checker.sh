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
# @Author    :   dev
# @Contact   :
# @Date      :   2026-07-08
# @License   :   Mulan PSL v2
# @Desc      :   gperftools-Heap checker memory leak detection
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to config params of the case."
    LOG_INFO "No params need to config."
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gperftools gperftools-devel gcc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test 1: Compile memory leak test program
    gcc -o /tmp/mem_leak_test common/mem_leak_test.c -ltcmalloc
    CHECK_RESULT $? 0 0 "Failed to compile memory leak test"

    # Test 2: Run with HEAPCHECK=normal to detect leak
    HEAPCHECK=normal /tmp/mem_leak_test 2>&1 | tee /tmp/heapcheck_leak.log
    grep -qi "leak" /tmp/heapcheck_leak.log
    CHECK_RESULT $? 0 0 "Heap checker did not detect memory leak"

    # Test 3: Compile no leak test program
    gcc -o /tmp/no_leak_test common/no_leak_test.c -ltcmalloc
    CHECK_RESULT $? 0 0 "Failed to compile no leak test"

    # Test 4: Run HEAPCHECK with no leak program
    HEAPCHECK=normal /tmp/no_leak_test 2>&1 | tee /tmp/heapcheck_noleak.log
    CHECK_RESULT $? 0 0 "No leak test failed with heap checker"

    # Test 5: Verify no leak is reported for clean program
    grep -qi "no leaks" /tmp/heapcheck_noleak.log || grep -qi "0 leaks" /tmp/heapcheck_noleak.log || grep -qi "passed" /tmp/heapcheck_noleak.log
    CHECK_RESULT $? 0 0 "Heap checker incorrectly reported leak for clean program"

    # Test 6: Check heap checker header exists
    test -f /usr/include/gperftools/heap-checker.h
    CHECK_RESULT $? 0 0 "heap-checker.h header not found"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/mem_leak_test /tmp/no_leak_test /tmp/heapcheck_leak.log /tmp/heapcheck_noleak.log
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
