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
# @Desc      :   Test ldns-rrsig command - inspect RRSIG records
# #############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

# The root zone "." is DNSSEC-signed, so RRSIG queries against it always succeed.
# Using a public domain like openeuler.org fails: ldns-rrsig reports
# "invalid answer name" because the answer does not carry the queried RRSIG.
ROOT_ZONE="."

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ldns ldns-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Smoke test: ldns-rrsig does not support -h; running without args shows usage
    ldns-rrsig 2>&1 | grep -i "rrsig"
    CHECK_RESULT $? 0 0 "ldns-rrsig does not show usage information"

    # Query RRSIG for the root zone (default type SOA): the root zone is signed,
    # so output contains "RRSIG(SOA)" with human-readable dates.
    ldns-rrsig "${ROOT_ZONE}" 2>&1 | grep -i "RRSIG"
    CHECK_RESULT $? 0 0 "ldns-rrsig failed to query RRSIG for root zone"

    # Query RRSIG for a specific record type (SOA) explicitly
    ldns-rrsig "${ROOT_ZONE}" SOA 2>&1 | grep -i "RRSIG"
    CHECK_RESULT $? 0 0 "ldns-rrsig failed to query RRSIG SOA for root zone"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
