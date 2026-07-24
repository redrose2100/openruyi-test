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
# @Desc      :   Test adig command - c-ares asynchronous DNS query tool
# #############################################
# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh
source "${OET_PATH}"/testcases/cli-test/c-ares/common/checkenv.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    check_c_ares_version
    DNF_INSTALL "c-ares-utils"
    mkdir -p /tmp/c-ares_test
    test_dir="/tmp/c-ares_test"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Verify adig help output shows usage
    adig -h 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "adig -h does not show usage"

    # Test basic DNS query: resolve localhost
    adig localhost > "${test_dir}"/adig_basic.txt 2>&1
    CHECK_RESULT $? 0 0 "adig failed to query localhost"
    grep -E "127\.0\.0\.1|localhost" "${test_dir}"/adig_basic.txt
    CHECK_RESULT $? 0 0 "adig basic query did not return expected result"

    # Test -t A: query A record type
    adig -t A localhost > "${test_dir}"/adig_a.txt 2>&1
    CHECK_RESULT $? 0 0 "adig -t A failed"
    grep -E "127\.0\.0\.1|IN A" "${test_dir}"/adig_a.txt
    CHECK_RESULT $? 0 0 "adig -t A did not return A record"

    # Test -t AAAA: query AAAA record type
    adig -t AAAA localhost > "${test_dir}"/adig_aaaa.txt 2>&1
    CHECK_RESULT $? 0 0 "adig -t AAAA failed"

    # Test -T: use TCP transport instead of UDP
    adig -T localhost > "${test_dir}"/adig_tcp.txt 2>&1
    CHECK_RESULT $? 0 0 "adig -T (TCP transport) failed"
    grep -E "127\.0\.0\.1|localhost" "${test_dir}"/adig_tcp.txt
    CHECK_RESULT $? 0 0 "adig -T did not return expected result"

    # Test -s: specify a DNS server explicitly
    adig -s 127.0.0.1 localhost > "${test_dir}"/adig_server.txt 2>&1
    CHECK_RESULT $? 0 0 "adig -s (specify DNS server) failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${test_dir}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
