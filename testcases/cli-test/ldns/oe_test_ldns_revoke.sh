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
# @Desc      :   Test ldns-revoke command - revoke DNSSEC keys
# #############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

TEST_DIR="/tmp/ldns_test"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ldns ldns-devel"
    mkdir -p "${TEST_DIR}"
    # Generate a key whose DNSKEY record will be revoked by ldns-revoke
    # keygen writes .key/.private (and possibly .ds) to CWD; move to TEST_DIR
    key_name=$(ldns-keygen -a RSASHA1 -b 512 example.test)
    mv -f "${key_name}.key" "${key_name}.private" "${TEST_DIR}/"
    [ -f "${key_name}.ds" ] && mv -f "${key_name}.ds" "${TEST_DIR}/"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    ldns-revoke 2>&1 | grep -i "keyfile"
    CHECK_RESULT $? 0 0 "ldns-revoke does not show usage information"

    # Test -n option: revoke to stdout without modifying the original file.
    # Output should contain "DNSKEY" and the revoke flag (256+128=384 in DNSKEY
    # flags field, or just match "revoked" confirmation message)
    ldns-revoke -n "${TEST_DIR}/${key_name}.key" 2>&1 | grep -i -E "DNSKEY|revoked"
    CHECK_RESULT $? 0 0 "ldns-revoke -n failed to output revoked DNSKEY record"

    # Test default mode: revoke writes back to the original file and prints
    # "DNSKEY revoked" to stdout. Verify the file still contains DNSKEY record.
    ldns-revoke "${TEST_DIR}/${key_name}.key" 2>&1 | grep -i "revoked"
    CHECK_RESULT $? 0 0 "ldns-revoke did not print revoked confirmation"
    grep "DNSKEY" "${TEST_DIR}/${key_name}.key"
    CHECK_RESULT $? 0 0 "ldns-revoke corrupted the key file (no DNSKEY record)"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${TEST_DIR}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
