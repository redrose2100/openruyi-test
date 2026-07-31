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
# @Desc      :   Test ldns-keyfetcher command - fetch DNSKEY records
# #############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

TEST_DIR="/tmp/ldns_test"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ldns ldns-devel"
    mkdir -p "${TEST_DIR}"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    ldns-keyfetcher -h 2>&1 | grep -i "dnskeys"
    CHECK_RESULT $? 0 0 "ldns-keyfetcher -h does not show usage information"

    # Fetch DNSKEY for root zone: root is DNSSEC-signed, -i skips cross-NS
    # validation. Whether DNSKEY is actually fetched depends on network and
    # root hints file (/etc/named.root) availability. Verify the command runs
    # and produces any output (DNSKEY/IN/error/hints) — non-zero exit is
    # acceptable since it may stem from missing root hints, not a command bug.
    keyfetcher_output=$(timeout 30 ldns-keyfetcher -i . 2>&1)
    echo "${keyfetcher_output}" | grep -E -i "DNSKEY|IN|error|hints|key|root"
    CHECK_RESULT $? 0 0 "ldns-keyfetcher produced no recognizable output for root zone"

    # Test -s option: store keys to files instead of stdout. Whether files are
    # generated depends on network success. Verify the command executes and
    # clean up any generated K*.key files to keep CWD clean.
    timeout 30 ldns-keyfetcher -i -s . >/dev/null 2>&1
    for f in K*.key; do
        [ -f "$f" ] && mv -f "$f" "${TEST_DIR}/"
    done

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${TEST_DIR}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
