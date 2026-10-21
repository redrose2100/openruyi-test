#!/usr/bin/bash

# Copyright (c) 2025 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2025-08-13
# @License   :   Mulan PSL v2
# @Desc      :   ebtables command testing
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ebtables"
    ebtables -F
    ebtables -X
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    ebtables --version
    CHECK_RESULT $? 0 0 "Failed to get ebtables version"

    ebtables -A INPUT -p IPv4 -j ACCEPT
    CHECK_RESULT $? 0 0 "Failed to add filter rule"
    ebtables -L INPUT | grep -q "IPv4"
    CHECK_RESULT $? 0 0 "Failed to find the added rule in listing"

    ebtables -D INPUT -p IPv4 -j ACCEPT
    CHECK_RESULT $? 0 0 "Failed to delete filter rule"
    ebtables -L INPUT | grep -q "IPv4"
    CHECK_RESULT $? 1 0 "Rule still exists after deletion"

    ebtables -N TEST_CHAIN
    CHECK_RESULT $? 0 0 "Failed to create new chain"
    ebtables -L | grep -q "TEST_CHAIN"
    CHECK_RESULT $? 0 0 "New chain not found in listing"
    ebtables -X TEST_CHAIN
    CHECK_RESULT $? 0 0 "Failed to delete chain"
    ebtables -L | grep -q "TEST_CHAIN"
    CHECK_RESULT $? 1 0 "Chain still exists after deletion"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ebtables -F
    while IFS= read -r chain; do
        ebtables -X "$chain"
    done < <(ebtables -L | awk '/^TEST_/ {print $1}')
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"