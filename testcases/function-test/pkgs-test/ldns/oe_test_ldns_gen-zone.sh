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
# @Desc      :   Test ldns-gen-zone command - generate zone files
# #############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

TEST_DIR="/tmp/ldns_test"
ZONE_SRC="${OET_PATH}/testcases/function-test/pkgs-test/ldns/common/zone.db"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ldns ldns-devel"
    mkdir -p "${TEST_DIR}"
    cp -f "${ZONE_SRC}" "${TEST_DIR}/zone.db"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # ldns-gen-zone -h shows usage mentioning gen-zone
    ldns-gen-zone -h 2>&1 | grep -i -E "usage|gen-zone"
    CHECK_RESULT $? 0 0 "ldns-gen-zone -h does not show usage information"

    # A zonefile argument MUST be given, otherwise it blocks reading from stdin.
    ldns-gen-zone "${TEST_DIR}/zone.db" 2>&1 | grep -E "IN[[:space:]]+(SOA|A|NS)"
    CHECK_RESULT $? 0 0 "ldns-gen-zone failed to generate DNS records"

    # Add 5 artificial delegations (-a 5): output should contain NS records
    ldns-gen-zone -a 5 "${TEST_DIR}/zone.db" 2>&1 | grep -E "IN[[:space:]]+NS"
    CHECK_RESULT $? 0 0 "ldns-gen-zone -a 5 failed to add artificial NS records"

    # Generate with explicit origin (-o): output should contain the origin
    ldns-gen-zone -o example.test. "${TEST_DIR}/zone.db" 2>&1 | grep "example.test"
    CHECK_RESULT $? 0 0 "ldns-gen-zone -o failed to set the origin"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${TEST_DIR}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
