#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   caowenqian
#@Contact       :   caowenqian@uniontech.com
#@Date          :   2026-06-23
#@License       :   Mulan PSL v2
#@Desc          :   Test case for uniq command
#####################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

# Global temporary file paths, set in pre_test()
TEST_INPUT=""
TEST_OUTPUT=""

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    # Create temporary files using mktemp to avoid conflicts and symlink attacks
    TEST_INPUT=$(mktemp /tmp/test_uniq_input.XXXXXX)
    TEST_OUTPUT=$(mktemp /tmp/test_uniq_output.XXXXXX)

    cat > "$TEST_INPUT" << EOF
apple
apple
banana
cherry
cherry
cherry
date
EOF

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test 1: basic uniq (no options) - remove adjacent duplicates
    uniq "$TEST_INPUT" > "$TEST_OUTPUT"
    CHECK_RESULT $? 0 0 "uniq without options failed"
    expected=$(printf "apple\nbanana\ncherry\ndate\n")
    result=$(cat "$TEST_OUTPUT")
    CHECK_RESULT $? 0 0 "Reading uniq output failed"
    test "$result" = "$expected"
    CHECK_RESULT $? 0 0 "uniq default output mismatch"

    # Test 2: uniq with -c (count)
    uniq -c "$TEST_INPUT" > "$TEST_OUTPUT"
    CHECK_RESULT $? 0 0 "uniq -c failed"
    expected=$(printf "      2 apple\n      1 banana\n      3 cherry\n      1 date\n")
    result=$(cat "$TEST_OUTPUT")
    test "$result" = "$expected"
    CHECK_RESULT $? 0 0 "uniq -c output mismatch"

    # Test 3: uniq with -d (only repeated lines)
    uniq -d "$TEST_INPUT" > "$TEST_OUTPUT"
    CHECK_RESULT $? 0 0 "uniq -d failed"
    expected=$(printf "apple\ncherry\n")
    result=$(cat "$TEST_OUTPUT")
    test "$result" = "$expected"
    CHECK_RESULT $? 0 0 "uniq -d output mismatch"

    # Test 4: uniq with -D (all duplicate lines)
    uniq -D "$TEST_INPUT" > "$TEST_OUTPUT"
    CHECK_RESULT $? 0 0 "uniq -D failed"
    expected=$(printf "apple\napple\ncherry\ncherry\ncherry\n")
    result=$(cat "$TEST_OUTPUT")
    test "$result" = "$expected"
    CHECK_RESULT $? 0 0 "uniq -D output mismatch"

    # Test 5: uniq reading from stdin
    # Use printf instead of echo -e for consistent escape interpretation
    printf "a\na\nb\nc\nc\n" | uniq > "$TEST_OUTPUT"
    CHECK_RESULT $? 0 0 "uniq stdin failed"
    expected=$(printf "a\nb\nc\n")
    result=$(cat "$TEST_OUTPUT")
    test "$result" = "$expected"
    CHECK_RESULT $? 0 0 "uniq stdin output mismatch"

    # Test 6: uniq with -i (case-insensitive)
    cat > "$TEST_INPUT" << EOF
Apple
apple
Banana
BANANA
Cherry
EOF
    uniq -i "$TEST_INPUT" > "$TEST_OUTPUT"
    CHECK_RESULT $? 0 0 "uniq -i failed"
    expected=$(printf "Apple\nBanana\nCherry\n")
    result=$(cat "$TEST_OUTPUT")
    test "$result" = "$expected"
    CHECK_RESULT $? 0 0 "uniq -i output mismatch"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    # Remove temporary files
    [[ -f "$TEST_INPUT" ]] && rm -f "$TEST_INPUT"
    [[ -f "$TEST_OUTPUT" ]] && rm -f "$TEST_OUTPUT"

    LOG_INFO "End to restore the test environment."
}

main "$@"
