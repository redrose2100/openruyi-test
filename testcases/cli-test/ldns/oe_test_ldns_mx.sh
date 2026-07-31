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
# @Desc      :   Test ldns-mx command - MX record query
# #############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

# ldns-mx only takes a domain argument (no -s/-h options); it uses the default
# resolver. Query a real domain that has MX records.
TEST_DOMAIN="openeuler.org"
TEST_DOMAIN_2="gmail.com"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ldns ldns-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # ldns-mx does not support -h; running without args shows usage
    ldns-mx 2>&1 | grep -i "mx"
    CHECK_RESULT $? 0 0 "ldns-mx does not show usage information"

    # Test basic MX query using default resolver: output should contain MX or IN
    ldns-mx "${TEST_DOMAIN}" 2>&1 | grep -E "MX|IN"
    CHECK_RESULT $? 0 0 "ldns-mx failed to query MX record for ${TEST_DOMAIN}"

    # Test MX query for another domain: output should contain MX or IN
    ldns-mx "${TEST_DOMAIN_2}" 2>&1 | grep -E "MX|IN"
    CHECK_RESULT $? 0 0 "ldns-mx failed to query MX record for ${TEST_DOMAIN_2}"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
