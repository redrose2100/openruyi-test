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
# @Desc      :   Test ldns-nsec3-hash command - compute NSEC3 hashes
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

    # ldns-nsec3-hash -h shows syntax (no "usage" keyword, grep for NSEC3)
    ldns-nsec3-hash -h 2>&1 | grep -i "nsec3"
    CHECK_RESULT $? 0 0 "ldns-nsec3-hash -h does not show usage information"

    # Compute NSEC3 hash of example.test: output contains a 32-char Base32hex token
    # (may be followed by domain suffix, so match within the line, not the whole line)
    ldns-nsec3-hash example.test | grep -E "[0-9A-Za-z]{32}"
    CHECK_RESULT $? 0 0 "ldns-nsec3-hash did not produce a 32-char Base32hex hash"

    # Compute NSEC3 hash with 5 iterations (-t 5)
    ldns-nsec3-hash -t 5 example.test | grep -E "[0-9A-Za-z]{32}"
    CHECK_RESULT $? 0 0 "ldns-nsec3-hash -t 5 did not produce a valid hash"

    # Compute NSEC3 hash with salt "ABCD" (-s ABCD)
    ldns-nsec3-hash -s ABCD example.test | grep -E "[0-9A-Za-z]{32}"
    CHECK_RESULT $? 0 0 "ldns-nsec3-hash -s ABCD did not produce a valid hash"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${TEST_DIR}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
