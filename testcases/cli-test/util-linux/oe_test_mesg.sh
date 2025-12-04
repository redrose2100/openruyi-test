#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   Lufei
#@Contact       :   lufei@uniontech.com
#@Date          :   2025-12-03
#@License       :   Mulan PSL v2
#@Desc          :   Test case for mesg command
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "util-linux"
    # Save original mesg state
    original_mesg_state=$(mesg | awk '{print $2}')
    LOG_INFO "Original mesg state is $original_mesg_state."
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test 1: mesg without arguments
    LOG_INFO "Test mesg without arguments."
    local exp
    local mesg_output
    local verbose_output
    if [[ "$original_mesg_state" == "n" ]]; then
        exp=1
    else
        exp=0
    fi
    mesg
    CHECK_RESULT $? "$exp" 0 "mesg without arguments failed"
    # Test 2: mesg y (allow writing)
    LOG_INFO "Test mesg y."
    mesg y
    CHECK_RESULT $? 0 0 "mesg y failed"
    mesg_output=$(mesg)
    [[ $mesg_output == *"is y"* ]]
    CHECK_RESULT $? 0 0 "mesg y did not set state to allowed"
    # Test 3: mesg n (disallow writing)
    LOG_INFO "Test mesg n."
    mesg n
    CHECK_RESULT $? 1 0 "mesg n failed"
    mesg_output=$(mesg)
    [[ "$mesg_output" == *"is n"* ]]
    CHECK_RESULT $? 0 0 "mesg n did not set state to disallowed"
    # Test 4: verbose option
    LOG_INFO "Test mesg -v y."
    verbose_output=$(mesg -v y)
    CHECK_RESULT $? 0 0 "mesg -v y failed"
    [[ $verbose_output == *"is allowed"* ]]
    CHECK_RESULT $? 0 0 "mesg -v y output missing expected message"
    # Test 5: help option
    LOG_INFO "Test mesg --help."
    mesg --help
    CHECK_RESULT $? 0 0 "mesg --help failed"
    # Test 6: version option
    LOG_INFO "Test mesg --version."
    mesg --version
    CHECK_RESULT $? 0 0 "mesg --version failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    # Restore original mesg state
    if [[ $original_mesg_state == "y" ]]; then
        mesg y
    elif [[ $original_mesg_state == "n" ]]; then
        mesg n
    fi
    # shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "Restored mesg state to $original_mesg_state."
    LOG_INFO "End to restore the test environment."
}

main "$@"
