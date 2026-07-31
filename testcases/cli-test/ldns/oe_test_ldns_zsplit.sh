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
# @Desc      :   Test ldns-zsplit command - split zone files
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

    # Smoke test: ldns-zsplit does not support -h; it prints Usage to stderr on
    # invalid option. Run without args to see usage mentioning "split".
    ldns-zsplit 2>&1 | grep -i -E "usage|split"
    CHECK_RESULT $? 0 0 "ldns-zsplit does not show usage information"

    # Basic split: output files generated in CWD, move to TEST_DIR for inspection
    ldns-zsplit "${TEST_DIR}/zone.db"
    CHECK_RESULT $? 0 0 "ldns-zsplit failed to split zone file"
    mv -f zone.db.0* "${TEST_DIR}/"
    test -f "${TEST_DIR}/zone.db.000"
    CHECK_RESULT $? 0 0 "ldns-zsplit did not create zone.db.000"
    rm -f "${TEST_DIR}/zone.db.0"*

    # Split into 2 parts: verify 2 output files are created (.000 and .001)
    ldns-zsplit -n 2 "${TEST_DIR}/zone.db"
    CHECK_RESULT $? 0 0 "ldns-zsplit -n 2 failed to split zone file"
    mv -f zone.db.0* "${TEST_DIR}/"
    test -f "${TEST_DIR}/zone.db.000"
    CHECK_RESULT $? 0 0 "ldns-zsplit -n 2 did not create zone.db.000"
    test -f "${TEST_DIR}/zone.db.001"
    CHECK_RESULT $? 0 0 "ldns-zsplit -n 2 did not create zone.db.001"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${TEST_DIR}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
