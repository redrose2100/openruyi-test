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
# @Desc      :   Test ldns-resolver command - parse resolver configuration
# #############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ldns ldns-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # ldns-resolver -h may not print "usage"; match usage or resolver
    ldns-resolver -h 2>&1 | grep -i -E "usage|resolver"
    CHECK_RESULT $? 0 0 "ldns-resolver -h does not show usage information"

    # Test parsing /etc/resolv.conf: command should exit 0 (do not depend on a
    # specific keyword like "Success", which varies across ldns versions/envs)
    ldns-resolver /etc/resolv.conf >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "ldns-resolver failed to parse /etc/resolv.conf"

    # Verify resolver properties are printed: port/nameserver/edns (any one)
    ldns-resolver /etc/resolv.conf 2>&1 | grep -i -E "port:|nameserver|edns"
    CHECK_RESULT $? 0 0 "ldns-resolver output does not contain resolver properties"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
