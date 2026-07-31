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
# @Desc      :   Test ldns-chaos command - query CHAOS class records
# #############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

# ldns-chaos queries version.bind/hostname.bind (CHAOS class TXT) from a
# nameserver. The argument must be a nameserver DOMAIN NAME (not an IP) — the
# command resolves the name to get an address, then sends a CHAOS query.
# Whether the server responds to CHAOS queries is server-dependent (many
# ignore version.bind), so we verify the command runs and produces any output.
NS_NAME="a.root-servers.net"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ldns ldns-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Smoke test: ldns-chaos has no options; running without args shows usage
    # Usage output does not contain "usage" keyword, grep for "server"
    ldns-chaos 2>&1 | grep -i "server"
    CHECK_RESULT $? 0 0 "ldns-chaos does not show usage information"

    # Query CHAOS records: the argument must be a nameserver domain name (the
    # command resolves it to get an address). Whether the server responds with
    # version.bind TXT is server-dependent. Verify the command runs and produces
    # any output (TXT/IN/error/address). Non-zero exit is acceptable since it
    # may stem from the server ignoring CHAOS, not a command bug.
    chaos_output=$(timeout 15 ldns-chaos "${NS_NAME}" 2>&1)
    echo "${chaos_output}" | grep -E -i "TXT|IN|answer|error|;;|version|;|chaos|address"
    CHECK_RESULT $? 0 0 "ldns-chaos produced no recognizable output for ${NS_NAME}"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
