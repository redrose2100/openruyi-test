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
# @Desc      :   Verify pwmake password generation functionality
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
    rpm -q libpwquality | grep "libpwquality"
    CHECK_RESULT $? 0 0 "Failed to install libpwquality package"
    rpm -V libpwquality
    CHECK_RESULT $? 0 0 "libpwquality package verification failed"
    rpm -ql libpwquality | grep -E "\.(so|so\.[0-9]+)$"
    CHECK_RESULT $? 0 0 "libpwquality shared library missing"
    pwmake --help 2>&1 | grep "pwmake"
    CHECK_RESULT $? 0 0 "Failed to run pwmake --help"
    pwmake 12 | grep -E '[][a-zA-Z0-9!@#$%^&*()_+=;.,~/-]{8,}' | wc -L | grep -E '1[23]$'
    CHECK_RESULT $? 0 0 "pwmake 12 generated invalid password"
    pwmake 56 | grep -E '[][a-zA-Z0-9!@#$%^&*()_+=;.,~/-]{8,}' | wc -L | grep -E '1[23]$'
    CHECK_RESULT $? 0 0 "pwmake 56 generated invalid password"
    pwmake 128 | grep -E '[][a-zA-Z0-9!@#$%^&*()_+=;.,~/-]{8,}' | wc -L | grep -E '2[6-8]$'
    CHECK_RESULT $? 0 0 "pwmake 128 generated invalid password"
    pwmake 256 | grep -E '[][a-zA-Z0-9!@#$%^&*()_+=;.,~/-]{8,}' | wc -L | grep -E '5[3-5]$'
    CHECK_RESULT $? 0 0 "pwmake 256 generated invalid password"
    pwmake 512 | grep -E '[][a-zA-Z0-9!@#$%^&*()_+=;.,~/-]{8,}' | wc -L | grep -E '5[3-5]$'
    CHECK_RESULT $? 0 0 "pwmake 512 generated invalid password"
    pwmake 56 | pwscore | grep -E "^[0-9]+$"
    CHECK_RESULT $? 0 0 "Failed to score pwmake 56 generated password"
    pwmake 128 | pwscore | grep -E "^[0-9]+$"
    CHECK_RESULT $? 0 0 "Failed to score pwmake 128 generated password"
    pwmake 256 | pwscore | grep -E "^[0-9]+$"
    CHECK_RESULT $? 0 0 "Failed to score pwmake 256 generated password"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
