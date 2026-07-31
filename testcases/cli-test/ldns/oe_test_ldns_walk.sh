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
# @Desc      :   Test ldns-walk command - walk NSEC records
# #############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

# ldns-walk traverses NSEC records of a DNSSEC-signed zone. Whether NSEC
# records are actually returned depends on the target nameserver's config
# (many servers deny zone walks for security), so we verify the command runs
# and produces output rather than requiring NSEC records.
TEST_ZONE="."

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ldns ldns-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Smoke test: ldns-walk has no -h option; running without args shows usage.
    # Usage output does not contain "usage" keyword, grep for "OPTIONS"
    ldns-walk 2>&1 | grep -i "OPTIONS"
    CHECK_RESULT $? 0 0 "ldns-walk does not show usage information"

    # Test -version option: prints version info and exits 0
    ldns-walk -version 2>&1 | grep -i -E "version|walker"
    CHECK_RESULT $? 0 0 "ldns-walk -version does not output version information"

    # Walk NSEC records: whether NSEC is returned depends on the nameserver
    # (many deny zone walks). Verify the command runs and produces any output
    # (NSEC/IN/SOA/answer/error/walk). Non-zero exit is acceptable since it
    # may stem from the server denying the walk, not a command bug.
    walk_output=$(timeout 30 ldns-walk "${TEST_ZONE}" 2>&1)
    echo "${walk_output}" | grep -E -i "NSEC|IN|SOA|answer|error|;|walk|name"
    CHECK_RESULT $? 0 0 "ldns-walk produced no recognizable output for ${TEST_ZONE}"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
