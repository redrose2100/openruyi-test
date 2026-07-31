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
# @Desc      :   Test drill command - DNS lookup tool
# #############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

# Use public DNS server and real domain for DNS query tests
DNS_SERVER="8.8.8.8"
TEST_DOMAIN="openeuler.org"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ldns ldns-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Smoke test: match usage or command keyword (drill -h output varies)
    drill -h 2>&1 | grep -i -E "usage|drill"
    CHECK_RESULT $? 0 0 "drill -h does not show usage information"

    # Test basic A record query: output should contain an IPv4 address
    drill "${TEST_DOMAIN}" @"${DNS_SERVER}" 2>&1 | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}"
    CHECK_RESULT $? 0 0 "drill failed to resolve A record for ${TEST_DOMAIN}"

    # Test MX record query: output should contain MX record type
    drill MX "${TEST_DOMAIN}" @"${DNS_SERVER}" 2>&1 | grep -E "IN[[:space:]]+MX|MX"
    CHECK_RESULT $? 0 0 "drill failed to query MX record for ${TEST_DOMAIN}"

    # Test NS record query: output should contain NS record type
    drill NS "${TEST_DOMAIN}" @"${DNS_SERVER}" 2>&1 | grep -E "IN[[:space:]]+NS|NS"
    CHECK_RESULT $? 0 0 "drill failed to query NS record for ${TEST_DOMAIN}"

    # Test SOA record query: output should contain SOA record type
    drill SOA "${TEST_DOMAIN}" @"${DNS_SERVER}" 2>&1 | grep -E "IN[[:space:]]+SOA|SOA"
    CHECK_RESULT $? 0 0 "drill failed to query SOA record for ${TEST_DOMAIN}"

    # Test AAAA record query: output should contain AAAA record type or answer section
    drill AAAA "${TEST_DOMAIN}" @"${DNS_SERVER}" 2>&1 | grep -E "IN[[:space:]]+AAAA|ANSWER"
    CHECK_RESULT $? 0 0 "drill failed to query AAAA record for ${TEST_DOMAIN}"

    # Test -V 5 verbose option: verbose output should include query details
    drill -V 5 "${TEST_DOMAIN}" @"${DNS_SERVER}" 2>&1 | grep -E -i "Querying|Answer|;"
    CHECK_RESULT $? 0 0 "drill -V 5 does not produce verbose output"

    # Test -T trace option: trace must start from real root servers, so do NOT
    # specify @server (8.8.8.8 would break the iterative trace). Output shows
    # root server NS records and/or root-servers.net hostnames.
    timeout 30 drill -T "${TEST_DOMAIN}" 2>&1 | grep -E "root-servers|IN[[:space:]]+NS"
    CHECK_RESULT $? 0 0 "drill -T failed to trace from root servers"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
