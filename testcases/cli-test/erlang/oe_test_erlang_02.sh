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
# @Date      :   2025-08-22
# @License   :   Mulan PSL v2
# @Desc      :   erlang command testing
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "erlang-erts"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test 5: Test list operations and pattern matching
    LOG_INFO "Testing list operations..."
    list_output=$(erl -eval 'List = [1,2,3,4,5], [Head|Tail] = List, io:format("Head:~p,Tail:~p", [Head, Tail]), erlang:halt().' -noshell 2>/dev/null)
    CHECK_RESULT $? 0 0 "Failed to perform list operations"
    echo "$list_output" | grep -q "Head:1,Tail:\[2,3,4,5\]"
    CHECK_RESULT $? 0 0 "List operation output mismatch"
    LOG_INFO "List operations test passed: $list_output"

    # Test 6: Test process spawning and check process table
    LOG_INFO "Testing process spawning..."
    erl -eval 'Pid = spawn(fun() -> timer:sleep(100), io:format("done") end), erlang:halt().' -noshell
    CHECK_RESULT $? 0 0 "Failed to spawn process"
    # Check if erl processes are running properly
    pgrep -l beam | head -3
    LOG_INFO "Process spawning test completed"

    # Test 7: Test BIF functions and node information
    LOG_INFO "Testing BIF functions..."
    node_info=$(erl -eval 'io:format("~s", [node()]), erlang:halt().' -noshell 2>/dev/null)
    CHECK_RESULT $? 0 0 "Failed to test BIF functions"
    echo "$node_info" | grep -q "nonode"
    CHECK_RESULT $? 0 0 "Node information not as expected"
    LOG_INFO "BIF functions test passed: node = $node_info"

    # Test 8: Test system information and OTP version
    LOG_INFO "Testing system information..."
    otp_version=$(erl -eval 'io:format("~s", [erlang:system_info(otp_release)]), erlang:halt().' -noshell 2>/dev/null)
    CHECK_RESULT $? 0 0 "Failed to get system information"
    if echo "$otp_version" | grep -qE '^[0-9]+$'; then
        LOG_INFO "OTP version test passed: version $otp_version"
    else
        LOG_INFO "OTP version: $otp_version"
    fi

    # Test 9: Test tuple operations with complex output
    LOG_INFO "Testing tuple operations..."
    tuple_output=$(erl -eval 'Tuple = {ok, "test", 123}, {Status, Message, Number} = Tuple, io:format("Status:~p-Message:~s-Number:~p", [Status, Message, Number]), erlang:halt().' -noshell 2>/dev/null)
    CHECK_RESULT $? 0 0 "Failed to test tuple operations"
    echo "$tuple_output" | grep -q "Status:ok-Message:test-Number:123"
    CHECK_RESULT $? 0 0 "Tuple operation output mismatch"
    LOG_INFO "Tuple operations test passed: $tuple_output"

    # Test 10: Check erlang related files and directories
    LOG_INFO "Checking Erlang installation files..."
    if [ -d "/usr/lib64/erlang" ] || [ -d "/usr/lib/erlang" ]; then
        LOG_INFO "Erlang library directory exists"
    else
        LOG_WARN "Erlang library directory not found"
    fi

    if command -v erl >/dev/null 2>&1; then
        erl_path=$(command -v erl)
        LOG_INFO "Erlang executable found at: $erl_path"
    else
        LOG_WARN "Erlang executable not found in PATH"
    fi

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    # Clean up test files
    rm -f /tmp/erlang_test_output.txt
    # Remove any temporary erlang files
    find /tmp -name "erl_*" -type f -delete 2>/dev/null || true
    find /tmp -name "*.beam" -delete 2>/dev/null || true

    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"