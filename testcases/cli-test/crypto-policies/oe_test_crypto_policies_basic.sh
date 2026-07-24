#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/07/17
# @License   :   Mulan PSL v2
# @Desc      :   Test crypto-policies package installation and basic command functionality
# ############################################

# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "crypto-policies"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test package installation
    rpm -qa | grep  crypto-policies
    CHECK_RESULT $? 0 0 "crypto-policies package not installed"
    # Test command existence
    command -v update-crypto-policies
    CHECK_RESULT $? 0 0 "update-crypto-policies command not found"
    # Test --show option: display current applied crypto policy
    update-crypto-policies --show | grep -qE "^(DEFAULT|LEGACY|FUTURE|FIPS)(:[A-Z0-9-]+)?$"
    CHECK_RESULT $? 0 0 "update-crypto-policies --show output is not a valid policy"
    # Test --is-applied option: check if current configured policy is applied
    update-crypto-policies --is-applied
    CHECK_RESULT $? 0 0 "update-crypto-policies --is-applied failed"
    # Test config file content is a valid policy name
    grep -qE "^(DEFAULT|LEGACY|FUTURE|FIPS)(:[A-Z]+)?$" /etc/crypto-policies/config
    CHECK_RESULT $? 0 0 "crypto-policies config file content is not a valid policy"
    # Test back-ends directory existence
    [ -d "/etc/crypto-policies/back-ends" ]
    CHECK_RESULT $? 0 0 "crypto-policies back-ends directory not found"
    # Test state directory existence
    [ -d "/etc/crypto-policies/state" ]
    CHECK_RESULT $? 0 0 "crypto-policies state directory not found"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
