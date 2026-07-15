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
    pwmake --help 2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "log message: Failed to run command: pwmake --help"
    # Verify password generation with invalid entropy values (below minimum)
    pwmake 12 2>&1 | grep -E "[a-zA-Z0-9]+"
    CHECK_RESULT $? 0 0 "log message: Failed to run command: pwmake 12 (below minimum, adjusted)"
    # Verify password generation with valid entropy values (low, medium, high)
    pwmake 56 | grep -E "[a-zA-Z0-9]+"
    CHECK_RESULT $? 0 0 "log message: Failed to run command: pwmake 56 (low entropy)"
    pwmake 128 | grep -E "[a-zA-Z0-9]+"
    CHECK_RESULT $? 0 0 "log message: Failed to run command: pwmake 128 (medium entropy)"
    pwmake 256 | grep -E "[a-zA-Z0-9]+"
    CHECK_RESULT $? 0 0 "log message: Failed to run command: pwmake 256 (high entropy)"
    # Verify password generation with invalid entropy values (above maximum)
    pwmake 512 2>&1 | grep -E "[a-zA-Z0-9]+"
    CHECK_RESULT $? 0 0 "log message: Failed to run command: pwmake 512 (above maximum, adjusted)"
    # Verify generated password contains only valid characters
    PW_56=$(pwmake 56) && echo "${PW_56}" | grep -E '^[][a-zA-Z0-9!@#$%^&*()_+=;.,~/-]+$'
    CHECK_RESULT $? 0 0 "log message: pwmake 56 generated invalid characters"
    PW_128=$(pwmake 128) && echo "${PW_128}" | grep -E '^[][a-zA-Z0-9!@#$%^&*()_+=;.,~/-]+$'
    CHECK_RESULT $? 0 0 "log message: pwmake 128 generated invalid characters"
    PW_256=$(pwmake 256) && echo "${PW_256}" | grep -E '^[][a-zA-Z0-9!@#$%^&*()_+=;.,~/-]+$'
    CHECK_RESULT $? 0 0 "log message: pwmake 256 generated invalid characters"
    # Verify generated password strength using pwscore
    PW_56=$(pwmake 56) && echo "${PW_56}" | pwscore 2>&1 | grep -E "[0-9]+"
    CHECK_RESULT $? 0 0 "log message: Failed to score pwmake 56 generated password"
    PW_128=$(pwmake 128) && echo "${PW_128}" | pwscore 2>&1 | grep -E "[0-9]+"
    CHECK_RESULT $? 0 0 "log message: Failed to score pwmake 128 generated password"
    PW_256=$(pwmake 256) && echo "${PW_256}" | pwscore 2>&1 | grep -E "[0-9]+"
    CHECK_RESULT $? 0 0 "log message: Failed to score pwmake 256 generated password"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
