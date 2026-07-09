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
# @Desc      :   gperftools-TCMalloc basic functionality
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

    # Test 1: Compile with tcmalloc_minimal
    gcc -o /tmp/tcmalloc_test common/tcmalloc_test.c -ltcmalloc_minimal
    CHECK_RESULT $? 0 0 "Failed to compile with tcmalloc_minimal"

    # Test 2: Run program with tcmalloc_minimal
    /tmp/tcmalloc_test
    CHECK_RESULT $? 0 0 "tcmalloc_minimal basic test failed"

    # Test 3: Compile with tcmalloc
    gcc -o /tmp/tcmalloc_test common/tcmalloc_test.c -ltcmalloc
    CHECK_RESULT $? 0 0 "Failed to compile with tcmalloc"

    # Test 4: Run program with tcmalloc
    /tmp/tcmalloc_test
    CHECK_RESULT $? 0 0 "tcmalloc basic test failed"

    # Test 5: Check tcmalloc library files exist
    test -f /usr/lib64/libtcmalloc.so
    CHECK_RESULT $? 0 0 "libtcmalloc.so not found"

    test -f /usr/lib64/libtcmalloc_minimal.so
    CHECK_RESULT $? 0 0 "libtcmalloc_minimal.so not found"

    # Test 6: Check tcmalloc headers exist
    test -f /usr/include/gperftools/tcmalloc.h
    CHECK_RESULT $? 0 0 "tcmalloc.h header not found"

    # Test 7: Check tcmalloc debug library
    test -f /usr/lib64/libtcmalloc_debug.so
    CHECK_RESULT $? 0 0 "libtcmalloc_debug.so not found"

    # Test 8: Check combined profiler+tcmalloc library
    test -f /usr/lib64/libtcmalloc_and_profiler.so
    CHECK_RESULT $? 0 0 "libtcmalloc_and_profiler.so not found"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/tcmalloc_test
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
