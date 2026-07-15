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
# shellcheck disable=SC2119

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
    echo "123" | pwscore 2>&1 | grep -i "Password quality check failed"
    CHECK_RESULT $? 0 0 "Failed to detect too short password"
    echo "password" | pwscore 2>&1 | grep -i "Password quality check failed"
    CHECK_RESULT $? 0 0 "Failed to detect dictionary password"
    echo "qwerty" | pwscore 2>&1 | grep -i "Password quality check failed"
    CHECK_RESULT $? 0 0 "Failed to detect keyboard sequence password"
    echo "abc123" | pwscore 2>&1 | grep -i "Password quality check failed"
    CHECK_RESULT $? 0 0 "Failed to detect simple sequence password"
    echo "AAAAAA" | pwscore 2>&1 | grep -i "Password quality check failed"
    CHECK_RESULT $? 0 0 "Failed to detect same character password"
    echo "Xs72p@9z" | pwscore | grep -E "^[0-9]+$"
    CHECK_RESULT $? 0 0 "Failed to score low strength password"
    echo "HelloWorld99!" | pwscore | grep -E "^[0-9]+$"
    CHECK_RESULT $? 0 0 "Failed to score medium strength password"
    echo "Str0ngP@ssw0rd2024!" | pwscore | grep "^100$"
    CHECK_RESULT $? 0 0 "Failed to score high strength password"
    useradd testpwuser 2>/dev/null
    echo "testpwuser:123" | chpasswd 2>&1 | grep -i "fail\|error\|bad\|not allowed"
    CHECK_RESULT $? 0 0 "Failed to detect password change rejection"
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
