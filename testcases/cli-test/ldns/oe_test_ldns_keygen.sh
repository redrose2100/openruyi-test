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
# @Desc      :   Test ldns-keygen command - generate DNSSEC keys
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

    # ldns-keygen -h shows syntax (no "usage" keyword, grep for algorithm)
    ldns-keygen -h 2>&1 | grep -i "algorithm"
    CHECK_RESULT $? 0 0 "ldns-keygen -h does not show usage information"

    # Generate RSA SHA1 key (512-bit): keygen writes to CWD, move to TEST_DIR
    # grep also verifies the .key file exists (exits 2 if missing)
    # Some ldns versions also generate a .ds file; move it to TEST_DIR if present
    key_name_rsa1=$(ldns-keygen -a RSASHA1 -b 512 example.test)
    mv -f "${key_name_rsa1}.key" "${key_name_rsa1}.private" "${TEST_DIR}/"
    [ -f "${key_name_rsa1}.ds" ] && mv -f "${key_name_rsa1}.ds" "${TEST_DIR}/"
    grep "DNSKEY" "${TEST_DIR}/${key_name_rsa1}.key"
    CHECK_RESULT $? 0 0 "RSA SHA1 key file was not created or does not contain DNSKEY record"

    # Generate RSA SHA256 key (512-bit): keygen writes to CWD, move to TEST_DIR
    key_name_rsa256=$(ldns-keygen -a RSASHA256 -b 512 example.test)
    mv -f "${key_name_rsa256}.key" "${key_name_rsa256}.private" "${TEST_DIR}/"
    [ -f "${key_name_rsa256}.ds" ] && mv -f "${key_name_rsa256}.ds" "${TEST_DIR}/"
    grep "DNSKEY" "${TEST_DIR}/${key_name_rsa256}.key"
    CHECK_RESULT $? 0 0 "RSA SHA256 key file was not created or does not contain DNSKEY record"

    # Generate KSK (Key Signing Key) with RSA SHA1: KSK flag is 257
    # DNSKEY record line contains flag 257: "IN DNSKEY 257 3 5 ..."
    key_name_ksk=$(ldns-keygen -k -a RSASHA1 -b 512 example.test)
    mv -f "${key_name_ksk}.key" "${key_name_ksk}.private" "${TEST_DIR}/"
    [ -f "${key_name_ksk}.ds" ] && mv -f "${key_name_ksk}.ds" "${TEST_DIR}/"
    grep -E "DNSKEY[[:space:]]+257" "${TEST_DIR}/${key_name_ksk}.key"
    CHECK_RESULT $? 0 0 "KSK key file was not created or does not contain DNSKEY record with flag 257"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${TEST_DIR}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
