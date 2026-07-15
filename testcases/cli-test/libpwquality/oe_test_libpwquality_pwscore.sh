#!/usr/bin/bash
# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wangkun
# @Contact   :   wkun1005@163.com
# @Date      :   2026/07/14
# @License   :   Mulan PSL v2
# @Desc      :   Verify pwscore password strength testing functionality
# ############################################

source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libpwquality"
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    # Verify libpwquality package installation and integrity
    rpm -q libpwquality | grep "libpwquality"
    CHECK_RESULT $? 0 0 "Failed to install libpwquality package"
    rpm -V libpwquality
    CHECK_RESULT $? 0 0 "libpwquality package verification failed"
    rpm -ql libpwquality | grep -E "\.(so|so\.[0-9]+)$"
    CHECK_RESULT $? 0 0 "libpwquality shared library missing"
    # Verify pwscore detects too short password and returns error
    echo "123" | pwscore 2>&1 | grep -i "Password quality check failed"
    CHECK_RESULT $? 0 0 "log message: Failed to detect too short password"
    # Verify pwscore detects dictionary word and returns error
    echo "password" | pwscore 2>&1 | grep -i "Password quality check failed"
    CHECK_RESULT $? 0 0 "log message: Failed to detect dictionary password"
    # Verify pwscore detects keyboard sequence and returns error
    echo "qwerty" | pwscore 2>&1 | grep -i "Password quality check failed"
    CHECK_RESULT $? 0 0 "log message: Failed to detect keyboard sequence password"
    # Verify pwscore detects simple sequence and returns error
    echo "abc123" | pwscore 2>&1 | grep -i "Password quality check failed"
    CHECK_RESULT $? 0 0 "log message: Failed to detect simple sequence password"
    # Verify pwscore detects same characters and returns error
    echo "AAAAAA" | pwscore 2>&1 | grep -i "Password quality check failed"
    CHECK_RESULT $? 0 0 "log message: Failed to detect same character password"
    # Verify pwscore scores low strength password (returns score, not error)
    echo "Xs72p@9z" | pwscore 2>&1 | grep -E "[0-9]+"
    CHECK_RESULT $? 0 0 "log message: Failed to score low strength password"
    # Verify pwscore scores medium strength password (returns score, not error)
    echo "HelloWorld99!" | pwscore 2>&1 | grep -E "[0-9]+"
    CHECK_RESULT $? 0 0 "log message: Failed to score medium strength password"
    # Verify pwscore scores high strength password (returns score 100)
    echo "Str0ngP@ssw0rd2024!" | pwscore 2>&1 | grep "100"
    CHECK_RESULT $? 0 0 "log message: Failed to score high strength password"
    # Verify password error reporting via chpasswd
    useradd testpwuser 2>/dev/null
    echo "testpwuser:123" | chpasswd 2>&1 | grep -i "fail\|error\|bad\|PALMER\|not allowed"
    CHECK_RESULT $? 0 0 "log message: Failed to detect password change rejection"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start environment cleanup."
    userdel -rf testpwuser 2>/dev/null
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
