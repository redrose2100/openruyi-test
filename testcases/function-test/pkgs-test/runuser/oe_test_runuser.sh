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
#@Date          :   2026-06-15
#@License       :   Mulan PSL v2
#@Desc          :   Test case for runuser command
#####################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    
    LOG_INFO "Start to prepare the test environment."
    test_user="testuser_runuser"
    test_file="/tmp/runuser_test_file"
    useradd -m $test_user || { LOG_ERROR "Failed to create test user."; exit 1; }
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    
    LOG_INFO "Start to run test."
    # Test 1: run simple command as test user
    runuser -u $test_user whoami > /tmp/runuser_out1 2>&1
    CHECK_RESULT $? 0 0 "runuser -u $test_user whoami failed"
    grep -w "^$test_user$" /tmp/runuser_out1
    CHECK_RESULT $? 0 0 "Output not as expected: $(cat /tmp/runuser_out1)"
    # Test 2: run id command to verify effective user
    runuser -u $test_user -- id  -un > /tmp/runuser_out2 2>&1
    CHECK_RESULT $? 0 0 "runuser id command failed"
    grep -w "^$test_user$" /tmp/runuser_out2
    CHECK_RESULT $? 0 0 "id output mismatch: $(cat /tmp/runuser_out2)"
    # Test 3: run command with argument
    runuser -u $test_user ls /tmp > /tmp/runuser_out3 2>&1
    CHECK_RESULT $? 0 0 "runuser ls command failed"
    # Test 4: create file as test user
    runuser -u $test_user touch $test_file
    CHECK_RESULT $? 0 0 "runuser touch command failed"
    stat -c "%U" $test_file | grep -w "^$test_user$"
    CHECK_RESULT $? 0 0 "File owner not $test_user"
    LOG_INFO "End to run test."
}

function post_test() {
    
    LOG_INFO "Start to restore the test environment."
    rm -f /tmp/runuser_out1 /tmp/runuser_out2 /tmp/runuser_out3 $test_file
    userdel -r $test_user 2>/dev/null
    LOG_INFO "End to restore the test environment."
}

main "$@"
