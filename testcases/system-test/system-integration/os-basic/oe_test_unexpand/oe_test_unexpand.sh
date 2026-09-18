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
#@Author        :   fuyahong
#@Contact       :   fuyahong@uniontech.com
#@Date          :   2026-06-11
#@License       :   Mulan PSL v2
#@Desc          :   Test case for unexpand command
#####################################
# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {   
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL coreutils
    mkdir -p test_unexpand
    echo "        hello world        " > test_unexpand/input1
    echo "    hello    world" > test_unexpand/input2
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    
    LOG_INFO "Start to run test."
    # Test default behavior: convert leading 8-space groups to tabs
    expected=$(printf '\thello world        \n')
    actual=$(/usr/bin/unexpand test_unexpand/input1)
    CHECK_RESULT $? 0 0 "Default unexpand execution failed"
    [ "$actual" = "$expected" ]
    CHECK_RESULT $? 0 0 "Default unexpand leading space conversion failed"

    # Test --first-only: only convert first space group
    expected=$(printf '\thello    world\n')
    actual=$(/usr/bin/unexpand -t 4 --first-only test_unexpand/input2)
    CHECK_RESULT $? 0 0 "unexpand --first-only execution failed"
    [ "$actual" = "$expected" ]
    CHECK_RESULT $? 0 0 "unexpand --first-only failed to only convert first space group"

    # Test read from standard input with - argument
    expected=$(printf '\thello world\n')
    actual=$(echo "        hello world" | /usr/bin/unexpand -)
    CHECK_RESULT $? 0 0 "unexpand read from stdin execution failed"
    [ "$actual" = "$expected" ]
    CHECK_RESULT $? 0 0 "unexpand stdin conversion failed"

    # Test --version option output
    /usr/bin/unexpand --version > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "unexpand --version execution failed"

    # Test help option output
    /usr/bin/unexpand --help | grep -q "Usage:"
    CHECK_RESULT $? 0 0 "unexpand --help output check failed"

    LOG_INFO "End to run test."
}

function post_test() {   
    LOG_INFO "Start to restore the test environment."
    rm -rf test_unexpand
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
