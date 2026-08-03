#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zjl_long
# @Contact   :   zhu_jinlong@hoperun.com
# @Date      :   2026-08-03
# @License   :   Mulan PSL v2
# @Desc      :   libnetfilter_queue API functionality test - compile and run test program
# ############################################
# shellcheck disable=SC1090,SC2119,SC2046
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libnetfilter_queue libnetfilter_queue-devel gcc libmnl-devel libnfnetlink-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    local test_dir
    local output
    local ret_code
    test_dir="$(dirname "$0")"

    # Step 1: Compile the test program using pkg-config flags
    gcc -o /tmp/nfq_test "${test_dir}/nfq_test.c" $(pkg-config --cflags --libs libnetfilter_queue) 2>&1
    CHECK_RESULT $? 0 0 "Failed to compile nfq_test.c"

    # Step 2: Verify compiled binary exists
    test -x /tmp/nfq_test
    CHECK_RESULT $? 0 0 "nfq_test binary not found"

    # Step 3-10: Run test program and verify each API call
    # Capture output and exit code separately to avoid pipefail issues
    output=$(/tmp/nfq_test 2>&1)
    ret_code=$?

    # Check program exited successfully
    CHECK_RESULT $ret_code 0 0 "nfq_test program failed"

    # Step 3: Verify nfq_open succeeded
    echo "$output" | grep -q "ok: nfq_open() succeeded"
    CHECK_RESULT $? 0 0 "nfq_open() API test failed"

    # Step 4: Verify nfq_unbind_pf API call
    echo "$output" | grep -q "ok: nfq_unbind_pf() succeeded"
    CHECK_RESULT $? 0 0 "nfq_unbind_pf() API test failed"

    # Step 5: Verify nfq_bind_pf API call
    echo "$output" | grep -q "ok: nfq_bind_pf() succeeded"
    CHECK_RESULT $? 0 0 "nfq_bind_pf() API test failed"

    # Step 6: Verify nfq_create_queue API call
    echo "$output" | grep -q "ok: nfq_create_queue() succeeded"
    CHECK_RESULT $? 0 0 "nfq_create_queue() API test failed"

    # Step 7: Verify nfq_set_mode API call
    echo "$output" | grep -q "ok: nfq_set_mode"
    CHECK_RESULT $? 0 0 "nfq_set_mode() API test failed"

    # Step 8: Verify nfq_fd API call
    echo "$output" | grep -q "ok: nfq_fd() returned"
    CHECK_RESULT $? 0 0 "nfq_fd() API test failed"

    # Step 9: Verify nfq_destroy_queue API call
    echo "$output" | grep -q "ok: nfq_destroy_queue() succeeded"
    CHECK_RESULT $? 0 0 "nfq_destroy_queue() API test failed"

    # Step 10: Verify nfq_close API call and all tests passed
    echo "$output" | grep -q "all tests passed"
    CHECK_RESULT $? 0 0 "nfq_close() or overall test failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f /tmp/nfq_test
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
