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
# @Desc      :   Test ldns-key2ds command - convert DNSKEY to DS records
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
    # Generate a signing key whose DNSKEY record will be converted to DS
    key_name=$(ldns-keygen -a RSASHA1 -b 512 example.test)
    mv -f "${key_name}.key" "${key_name}.private" "${TEST_DIR}/"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Smoke test: ldns-key2ds -h shows syntax (no "usage" keyword, grep for keyfile)
    ldns-key2ds -h 2>&1 | grep -i "keyfile"
    CHECK_RESULT $? 0 0 "ldns-key2ds -h does not show usage information"

    # Convert DNSKEY to DS with SHA1 digest (-1), print to stdout (-n)
    # -f ignores SEP flag so DS is generated for non-KSK keys too
    ldns-key2ds -n -f -1 "${TEST_DIR}/${key_name}.key" > "${TEST_DIR}/ds_sha1.txt" 2>&1
    CHECK_RESULT $? 0 0 "ldns-key2ds -n -f -1 failed to convert DNSKEY to DS"
    grep -i -E "DS" "${TEST_DIR}/ds_sha1.txt"
    CHECK_RESULT $? 0 0 "ldns-key2ds -1 did not produce DS record"
    grep -i "example.test" "${TEST_DIR}/ds_sha1.txt"
    CHECK_RESULT $? 0 0 "ldns-key2ds -1 did not reference example.test"

    # Convert DNSKEY to DS with SHA256 digest (-2), print to stdout (-n)
    ldns-key2ds -n -f -2 "${TEST_DIR}/${key_name}.key" > "${TEST_DIR}/ds_sha256.txt" 2>&1
    CHECK_RESULT $? 0 0 "ldns-key2ds -n -f -2 failed to convert DNSKEY to DS"
    grep -i -E "DS" "${TEST_DIR}/ds_sha256.txt"
    CHECK_RESULT $? 0 0 "ldns-key2ds -2 did not produce DS record"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${TEST_DIR}"
    rm -f K*.ds
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
