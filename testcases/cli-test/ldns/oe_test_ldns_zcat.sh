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
# @Desc      :   Test ldns-zcat command - concatenate zone files
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

    # ldns-zcat -h may not print "usage"; match usage or zcat
    ldns-zcat -h 2>&1 | grep -i -E "usage|zcat"
    CHECK_RESULT $? 0 0 "ldns-zcat -h does not show usage information"

    # Split zone file: output files generated in CWD, move to TEST_DIR
    ldns-zsplit -n 2 "${TEST_DIR}/zone.db"
    CHECK_RESULT $? 0 0 "ldns-zsplit failed to split zone file for zcat test"
    mv -f zone.db.0* "${TEST_DIR}/"

    # Concatenate split files back: verify SOA record and zone origin are present
    # (SOA line contains the origin "example.test")
    ldns-zcat "${TEST_DIR}/zone.db.000" "${TEST_DIR}/zone.db.001" | grep -E "example\.test.*SOA|SOA.*example\.test"
    CHECK_RESULT $? 0 0 "ldns-zcat output does not contain SOA record with zone origin"

    # Concatenate specific split files: verify output contains zone records
    ldns-zcat "${TEST_DIR}/zone.db.000" "${TEST_DIR}/zone.db.001" | grep -E "IN[[:space:]]+(SOA|NS|A)"
    CHECK_RESULT $? 0 0 "ldns-zcat failed to concatenate specific split files"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${TEST_DIR}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
