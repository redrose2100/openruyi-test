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
# @Date      :   2026/07/23
# @License   :   Mulan PSL v2
# @Desc      :   Test ahost command - c-ares asynchronous host resolution tool
# #############################################
# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "c-ares c-ares-utils"
    mkdir -p /tmp/c-ares_test
    test_dir="/tmp/c-ares_test"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Verify ahost help output shows usage
    ahost -h 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "ahost -h does not show usage"

    # Test basic host resolution: resolve localhost via /etc/hosts
    ahost localhost > "${test_dir}"/ahost_basic.txt 2>&1
    CHECK_RESULT $? 0 0 "ahost failed to resolve localhost"
    grep -E "127\.0\.0\.1|localhost" "${test_dir}"/ahost_basic.txt
    CHECK_RESULT $? 0 0 "ahost basic resolution did not return expected result"

    # Test -t a: resolve IPv4 address only
    ahost -t a localhost > "${test_dir}"/ahost_a.txt 2>&1
    CHECK_RESULT $? 0 0 "ahost -t a failed"
    grep -E "127\.0\.0\.1|IN A" "${test_dir}"/ahost_a.txt
    CHECK_RESULT $? 0 0 "ahost -t a did not return IPv4 address"

    # Test -t aaaa: resolve IPv6 address only
    ahost -t aaaa localhost > "${test_dir}"/ahost_aaaa.txt 2>&1
    CHECK_RESULT $? 0 0 "ahost -t aaaa failed"

    # Test -t mx: query MX record type
    ahost -t mx localhost > "${test_dir}"/ahost_mx.txt 2>&1
    CHECK_RESULT $? 0 0 "ahost -t mx failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${test_dir}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
