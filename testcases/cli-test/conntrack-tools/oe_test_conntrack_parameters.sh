#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   caowenqian
# @Contact   :   caowenqian@uniontech.com
# @Date      :   2025/10/22
# @License   :   Mulan PSL v2
# @Desc      :   Test conntrack command parameters and options
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL conntrack-tools
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing conntrack command parameters..."
    
    # Test 1: List with protocol filter
    LOG_INFO "Test 3: List with protocol filter"
    OUTPUT=$(conntrack -L -p tcp 2>&1)
    RET=$?
    CHECK_RESULT $RET 0 0 "Failed to list with protocol filter"
    # Verify output format is correct - permission issues and empty output should fail
    if [ -z "$OUTPUT" ]; then
        LOG_INFO "Empty output detected for protocol filter test"
        CHECK_RESULT 1 0 0 "Protocol filter test failed: empty output is not acceptable"
    fi
    # Check if output contains error messages
    if echo "$OUTPUT" | grep -qiE "error|failed|cannot|permission denied|operation not permitted"; then
        LOG_INFO "Command output contains error messages: $(echo "$OUTPUT" | head -2)"
        # Permission issues should be marked as failure
        if echo "$OUTPUT" | grep -qiE "permission denied|operation not permitted|capability"; then
            LOG_INFO "Permission/capability issue detected, marking as failure"
            CHECK_RESULT 1 0 0 "Protocol filter test failed: permission denied"
        else
            CHECK_RESULT 1 0 0 "Conntrack command failed with unexpected error"
        fi
    else
        # Output should contain connection entries with the protocol
        # Verify output format contains connection-related content
        if echo "$OUTPUT" | grep -qE "tcp|udp|icmp|\[|conntrack"; then
            # Verify the protocol appears in the output (tcp should be present)
            echo "$OUTPUT" | grep -qiE "tcp|\[.*tcp"
            CHECK_RESULT $? 0 0 "Output does not contain expected protocol tcp"
        else
            LOG_INFO "Output does not contain connection entries"
            CHECK_RESULT 1 0 0 "Protocol filter test failed: output does not contain connection entries"
        fi
    fi
    
    # Test 2: List with family filter
    LOG_INFO "Test 4: List with family filter"
    OUTPUT=$(conntrack -L -f ipv4 2>&1)
    RET=$?
    CHECK_RESULT $RET 0 0 "Failed to list with family filter"
    # Verify output format is correct - permission issues and empty output should fail
    if [ -z "$OUTPUT" ]; then
        LOG_INFO "Empty output detected for family filter test"
        CHECK_RESULT 1 0 0 "Family filter test failed: empty output is not acceptable"
    fi
    # Check if output contains error messages
    if echo "$OUTPUT" | grep -qiE "error|failed|cannot|permission denied|operation not permitted"; then
        LOG_INFO "Command output contains error messages: $(echo "$OUTPUT" | head -2)"
        # Permission issues should be marked as failure
        if echo "$OUTPUT" | grep -qiE "permission denied|operation not permitted|capability"; then
            LOG_INFO "Permission/capability issue detected, marking as failure"
            CHECK_RESULT 1 0 0 "Family filter test failed: permission denied"
        else
            CHECK_RESULT 1 0 0 "Conntrack command failed with unexpected error"
        fi
    else
        # Output should contain connection entries with IPv4 addresses
        # Verify output format contains connection-related content
        if echo "$OUTPUT" | grep -qE "tcp|udp|icmp|\[|conntrack"; then
            # Verify output contains IPv4 addresses (not IPv6)
            echo "$OUTPUT" | grep -qE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"
            CHECK_RESULT $? 0 0 "Output does not contain expected IPv4 address format"
        else
            LOG_INFO "Output does not contain connection entries"
            CHECK_RESULT 1 0 0 "Family filter test failed: output does not contain connection entries"
        fi
    fi
    
    # Test 3: List with zero counters
    LOG_INFO "Test 5: List with zero counters"
    OUTPUT=$(conntrack -L -z 2>&1)
    RET=$?
    CHECK_RESULT $RET 0 0 "Failed to list with zero counters"
    # Verify output format is correct - permission issues and empty output should fail
    if [ -z "$OUTPUT" ]; then
        LOG_INFO "Empty output detected for zero counters test"
        CHECK_RESULT 1 0 0 "Zero counters test failed: empty output is not acceptable"
    fi
    # Check if output contains error messages
    if echo "$OUTPUT" | grep -qiE "error|failed|cannot|permission denied|operation not permitted"; then
        LOG_INFO "Command output contains error messages: $(echo "$OUTPUT" | head -2)"
        # Permission issues should be marked as failure
        if echo "$OUTPUT" | grep -qiE "permission denied|operation not permitted|capability"; then
            LOG_INFO "Permission/capability issue detected, marking as failure"
            CHECK_RESULT 1 0 0 "Zero counters test failed: permission denied"
        else
            CHECK_RESULT 1 0 0 "Conntrack command failed with unexpected error"
        fi
    else
        # Output should contain connection entries
        # Verify output format contains connection-related content
        if echo "$OUTPUT" | grep -qE "tcp|udp|icmp|\[|conntrack"; then
            LOG_INFO "Command executed successfully, output contains connection entries"
        else
            LOG_INFO "Output does not contain connection entries"
            CHECK_RESULT 1 0 0 "Zero counters test failed: output does not contain connection entries"
        fi
    fi
    
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    # shellcheck disable=SC2119
    DNF_REMOVE 
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
