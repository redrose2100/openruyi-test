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
# @Desc      :   Test ldns-config command - show compile configuration
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

    # Smoke test: ldns-config -h shows usage (contains "Usage" keyword)
    ldns-config -h 2>&1 | grep -i "Usage"
    CHECK_RESULT $? 0 0 "ldns-config -h does not show usage information"

    # Test --version: output should contain version digits
    ldns-config --version 2>&1 | grep -E "[0-9]+\.[0-9]+"
    CHECK_RESULT $? 0 0 "ldns-config --version does not output version information"

    # Test --cflags: output should contain include path flag -I
    ldns-config --cflags 2>&1 | grep -E "\-I|include"
    CHECK_RESULT $? 0 0 "ldns-config --cflags does not output include flags"

    # Test --libs: output should contain link flag -l or -L
    ldns-config --libs 2>&1 | grep -E "\-l|\-L"
    CHECK_RESULT $? 0 0 "ldns-config --libs does not output link flags"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
