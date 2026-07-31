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
# @Date      :   2026/07/22
# @License   :   Mulan PSL v2
# @Desc      :   Test ldns-test-edns command - EDNS support testing
# #############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

# ldns-test-edns takes a DNS cache IP address (not a domain name) and prints
# "<IP> OK" when EDNS is supported.
DNS_CACHE_IP="8.8.8.8"
DNS_CACHE_IP_2="8.8.4.4"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ldns ldns-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Smoke test: ldns-test-edns -h prints usage mentioning EDNS
    ldns-test-edns -h 2>&1 | grep -i -E "usage|edns"
    CHECK_RESULT $? 0 0 "ldns-test-edns -h does not show usage"

    # Test EDNS support of a public DNS cache: output should be "<IP> OK"
    ldns-test-edns "${DNS_CACHE_IP}" 2>&1 | grep -i -E "OK|edns"
    CHECK_RESULT $? 0 0 "ldns-test-edns failed to test EDNS support for ${DNS_CACHE_IP}"

    # Test EDNS support of another public DNS cache: output should be "<IP> OK"
    ldns-test-edns "${DNS_CACHE_IP_2}" 2>&1 | grep -i -E "OK|edns"
    CHECK_RESULT $? 0 0 "ldns-test-edns failed to test EDNS support for ${DNS_CACHE_IP_2}"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
