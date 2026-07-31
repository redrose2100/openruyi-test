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
# @Desc      :   Test ldns-signzone command - sign zone files with DNSSEC
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
    # Generate a signing key: keygen writes to CWD, move to TEST_DIR
    key_name=$(ldns-keygen -a RSASHA1 -b 512 example.test)
    mv -f "${key_name}.key" "${key_name}.private" "${TEST_DIR}/"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Smoke test: ldns-signzone -h shows syntax (no "usage" keyword, grep for zonefile)
    ldns-signzone -h 2>&1 | grep -i "zonefile"
    CHECK_RESULT $? 0 0 "ldns-signzone -h does not show usage information"

    # Sign the zone with the generated key, writing output to signed.zone
    # Key must be passed as basename (without .key); signzone appends .private itself
    ldns-signzone -f "${TEST_DIR}/signed.zone" "${TEST_DIR}/zone.db" "${TEST_DIR}/${key_name}"
    CHECK_RESULT $? 0 0 "ldns-signzone failed to sign zone"
    test -f "${TEST_DIR}/signed.zone"
    CHECK_RESULT $? 0 0 "signed.zone file was not created"
    grep "RRSIG" "${TEST_DIR}/signed.zone"
    CHECK_RESULT $? 0 0 "signed.zone does not contain RRSIG records"

    # Sign with -n flag (use NSEC3): use -f to specify output path explicitly
    ldns-signzone -n -f "${TEST_DIR}/zone.db.signed" "${TEST_DIR}/zone.db" "${TEST_DIR}/${key_name}"
    CHECK_RESULT $? 0 0 "ldns-signzone -n failed to sign zone"
    grep "RRSIG" "${TEST_DIR}/zone.db.signed"
    CHECK_RESULT $? 0 0 "ldns-signzone -n output does not contain RRSIG records"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${TEST_DIR}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
