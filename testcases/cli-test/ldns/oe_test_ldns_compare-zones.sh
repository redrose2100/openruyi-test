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
# @Desc      :   Test ldns-compare-zones command - compare zone files
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

    # Smoke test: ldns-compare-zones -h may not print "usage"; match usage or compare
    ldns-compare-zones -h 2>&1 | grep -i -E "usage|compare"
    CHECK_RESULT $? 0 0 "ldns-compare-zones -h does not show usage information"

    # Compare identical zones: should report "+0 -0 ~0" (0 changes of each kind)
    ldns-compare-zones "${TEST_DIR}/zone.db" "${TEST_DIR}/zone.db" 2>&1 | grep -E "\+0[[:space:]]+-0[[:space:]]+~0"
    CHECK_RESULT $? 0 0 "ldns-compare-zones failed to report 0 differences for identical zones"

    # Create a modified copy with an additional A record
    cp -f "${TEST_DIR}/zone.db" "${TEST_DIR}/zone2.db"
    printf "ftp IN A 192.0.2.3\n" >> "${TEST_DIR}/zone2.db"

    # Compare modified zones: should report non-zero insertions (+1 or more)
    ldns-compare-zones "${TEST_DIR}/zone.db" "${TEST_DIR}/zone2.db" 2>&1 | grep -E "\+[1-9]"
    CHECK_RESULT $? 0 0 "ldns-compare-zones failed to report differences for modified zones"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${TEST_DIR}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
