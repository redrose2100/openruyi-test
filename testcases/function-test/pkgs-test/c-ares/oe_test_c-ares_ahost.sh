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
# @Date      :   2026/07/23
# @License   :   Mulan PSL v2
# @Desc      :   Test ahost command - c-ares asynchronous host resolution tool
# #############################################
# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh
source "${OET_PATH}"/testcases/function-test/pkgs-test/c-ares/common/checkenv.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    check_c_ares_version
    DNF_INSTALL "c-ares-utils"
    mkdir -p /tmp/c-ares_test
    test_dir="/tmp/c-ares_test"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Verify ahost help output shows usage
    ahost -h 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "ahost -h does not show usage"

    # expect resolved IP addresses in the output.
    ahost openeuler.org > "${test_dir}"/ahost_basic.txt 2>&1
    CHECK_RESULT $? 0 0 "ahost failed to resolve openeuler.org"
    grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}" "${test_dir}"/ahost_basic.txt
    CHECK_RESULT $? 0 0 "ahost basic resolution did not return an IP address"

    # Test -t a: resolve IPv4 address only
    ahost -t a openeuler.org > "${test_dir}"/ahost_a.txt 2>&1
    CHECK_RESULT $? 0 0 "ahost -t a failed"
    grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}" "${test_dir}"/ahost_a.txt
    CHECK_RESULT $? 0 0 "ahost -t a did not return IPv4 address"

    # Test -t aaaa: resolve IPv6 address only
    ahost -t aaaa openeuler.org > "${test_dir}"/ahost_aaaa.txt 2>&1
    CHECK_RESULT $? 0 0 "ahost -t aaaa failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${test_dir}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
