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
# @Desc      :   Test conntrack basic commands functionality
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL conntrack-tools
    # Create some test connections for verification
    ping -c 1 127.0.0.1 > /dev/null 2>&1
    sleep 1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing conntrack basic commands..."
    
    # Test 1: List conntrack table and verify output format
    LOG_INFO "Test 1: List conntrack table"
    LIST_OUTPUT=$(conntrack -L 2>&1)
    CHECK_RESULT $? 0 0 "Failed to list conntrack table"
    # Verify output format: should contain protocol names or be empty (no connections)
    if [ -n "$LIST_OUTPUT" ]; then
        echo "$LIST_OUTPUT" | grep -E "^tcp|^udp|^icmp|^UNREPLIED|^ESTABLISHED" > /dev/null
        CHECK_RESULT $? 0 0 "Conntrack list output format incorrect"
    else
        LOG_INFO "No connections found, which is acceptable"
    fi
    
    # Test 2: Show conntrack statistics and verify output
    LOG_INFO "Test 2: Show conntrack statistics"
    STATS_OUTPUT=$(conntrack -S)
    CHECK_RESULT $? 0 0 "Failed to show conntrack statistics"
    echo "$STATS_OUTPUT" | grep -E "found|invalid|insert|delete|drop" > /dev/null
    CHECK_RESULT $? 0 0 "Statistics output format incorrect"
    
    # Test 3: List with specific table and verify table name
    LOG_INFO "Test 3: List dying table"
    conntrack -L dying
    CHECK_RESULT $? 0 0 "Failed to list dying table"
    
    # Test 4: Show counters and verify output is numeric
    LOG_INFO "Test 4: Show conntrack counters"
    COUNTER_OUTPUT=$(conntrack -C conntrack)
    CHECK_RESULT $? 0 0 "Failed to show conntrack counters"
    echo "$COUNTER_OUTPUT" | grep -E "^[0-9]+$" > /dev/null
    CHECK_RESULT $? 0 0 "Counter output is not numeric"
    
    # Test 5: List with XML output format and verify XML structure
    LOG_INFO "Test 5: List with XML output format"
    XML_OUTPUT=$(conntrack -L -o xml | head -10)
    CHECK_RESULT $? 0 0 "Failed to list with XML output format"
    echo "$XML_OUTPUT" | grep -E "<conntrack|<flow|<\?xml" > /dev/null
    CHECK_RESULT $? 0 0 "XML output format incorrect"
    
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
