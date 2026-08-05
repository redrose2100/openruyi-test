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
# @Desc      :   Test ldns-read-zone command - read zone files
# #############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

TEST_DIR="/tmp/ldns_test"
ZONE_SRC="${OET_PATH}/testcases/cli-test/ldns/common/zone.db"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ldns ldns-devel"
    mkdir -p "${TEST_DIR}"
    cp -f "${ZONE_SRC}" "${TEST_DIR}/zone.db"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # ldns-read-zone -h may not print "usage"; match usage or read-zone
    ldns-read-zone -h 2>&1 | grep -i -E "usage|read-zone"
    CHECK_RESULT $? 0 0 "ldns-read-zone -h does not show usage information"

    # Basic read: verify SOA record and zone origin are printed (SOA line
    # contains the origin "example.test")
    ldns-read-zone "${TEST_DIR}/zone.db" 2>&1 | grep -E "example\.test.*SOA|SOA.*example\.test"
    CHECK_RESULT $? 0 0 "ldns-read-zone does not output SOA record with zone origin"

    # Canonicalize zone: -c canonicalizes all RRs, output contains NS or A records
    ldns-read-zone -c "${TEST_DIR}/zone.db" 2>&1 | grep -E "IN[[:space:]]+(NS|A)"
    CHECK_RESULT $? 0 0 "ldns-read-zone -c does not output NS or A records"

    # Strip DNSSEC data: -s strips DNSSEC data, command should run successfully
    ldns-read-zone -s "${TEST_DIR}/zone.db" > "${TEST_DIR}/stripped.out" 2>&1
    CHECK_RESULT $? 0 0 "ldns-read-zone -s failed to strip DNSSEC data"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${TEST_DIR}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
