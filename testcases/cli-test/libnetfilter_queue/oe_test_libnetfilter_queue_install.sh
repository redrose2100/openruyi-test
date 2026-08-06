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
# @Desc      :   libnetfilter_queue install verification and package check
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL libnetfilter_queue
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Step 1: Verify libnetfilter_queue package is installed
    rpm -qa | grep -w libnetfilter_queue
    CHECK_RESULT $? 0 0 "libnetfilter_queue package not installed"

    # Step 2: Verify package info is accessible
    rpm -qi libnetfilter_queue > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Failed to get libnetfilter_queue package info"

    # Step 3: Verify shared library file exists
    local lib_file
    lib_file=$(rpm -ql libnetfilter_queue | grep 'libnetfilter_queue.so' | head -1)
    test -f "$lib_file"
    CHECK_RESULT $? 0 0 "libnetfilter_queue shared library not found"

    # Step 4: Verify library is loadable via ldconfig
    ldconfig -p | grep -q "libnetfilter_queue.so"
    CHECK_RESULT $? 0 0 "libnetfilter_queue not found in ldconfig cache"

    # Step 5: Verify library file list is not empty
    local file_count
    file_count=$(rpm -ql libnetfilter_queue | wc -l)
    [ "$file_count" -gt 0 ]
    CHECK_RESULT $? 0 0 "libnetfilter_queue package has no files"

    # Step 6: Verify package provides entry in rpm database
    rpm -q --provides libnetfilter_queue | grep -q "libnetfilter_queue.so"
    CHECK_RESULT $? 0 0 "libnetfilter_queue does not provide shared library"

    # Step 7: Verify package dependencies are satisfied
    rpm -q --requires libnetfilter_queue > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Failed to check libnetfilter_queue dependencies"

    # Step 8: Verify library SONAME via rpm query
    rpm -ql libnetfilter_queue | grep -q "libnetfilter_queue.so.1"
    CHECK_RESULT $? 0 0 "libnetfilter_queue SONAME library not found"

    # Step 9: Verify package summary is not empty
    rpm -q --qf '%{SUMMARY}' libnetfilter_queue | grep -q .
    CHECK_RESULT $? 0 0 "libnetfilter_queue package summary is empty"

    # Step 10: Verify package license field
    rpm -q --qf '%{LICENSE}' libnetfilter_queue | grep -q .
    CHECK_RESULT $? 0 0 "libnetfilter_queue package license is empty"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
