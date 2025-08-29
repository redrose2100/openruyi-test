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

# shellcheck source=/dev/null
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "erlang-erts"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    erl -version 2>&1 | grep -q "Erlang"
    CHECK_RESULT $? 0 0 "Failed to get Erlang version"

    list_output=$(erl -eval 'List = [1,2,3,4,5], [Head|Tail] = List, io:format("Head:~p,Tail:~p", [Head, Tail]), erlang:halt().' -noshell 2>/dev/null)
    CHECK_RESULT $? 0 0 "Failed to perform list operations"
    echo "$list_output" | grep -q "Head:1,Tail:\\[2,3,4,5\\]"
    CHECK_RESULT $? 0 0 "List operation output mismatch"

    test_file="/tmp/erlang_test_output.txt"
    erl -eval 'io:format("Hello from Erlang~n"), erlang:halt().' -noshell > "$test_file" 2>&1
    CHECK_RESULT $? 0 0 "Failed to run IO formatting"
    grep -q "Hello from Erlang" "$test_file"
    CHECK_RESULT $? 0 0 "Output file doesn't contain expected text"
    file_size=$(wc -c < "$test_file")
    test "$file_size" -gt 0
    CHECK_RESULT $? 0 0 "Output file is empty"
    rm -f "$test_file"

    test_file="/tmp/erlang_math_test.txt"
    erl -eval 'Result = 2 + 3 * 4, io:format("~p", [Result]), erlang:halt().' -noshell > "$test_file" 2>&1
    CHECK_RESULT $? 0 0 "Failed to perform arithmetic operations"
    grep -q "14" "$test_file"
    CHECK_RESULT $? 0 0 "Arithmetic result mismatch"
    rm -f "$test_file"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f /tmp/erlang_test_output.txt /tmp/erlang_math_test.txt
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"