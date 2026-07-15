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

set -o pipefail
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
    PWMAKE_HELP=$(pwmake --help 2>&1)
    echo "${PWMAKE_HELP}" | grep -E "Usage|pwmake"
    CHECK_RESULT $? 0 0 "log message: Failed to run command: pwmake --help"
    # Verify password generation with invalid entropy values (below minimum) - pwmake adjusts to minimum
    PW_12=$(pwmake 12)
    CHECK_RESULT $? 0 0 "log message: Failed to run command: pwmake 12 (below minimum)"
    echo "${PW_12}" | grep -E '[a-zA-Z0-9!@#$%^&*()_+=;.,~/-]{8,}'
    CHECK_RESULT $? 0 0 "log message: pwmake 12 generated invalid password"
    # Verify password generation with valid entropy values (low, medium, high)
    PW_56=$(pwmake 56)
    CHECK_RESULT $? 0 0 "log message: Failed to run command: pwmake 56 (low entropy)"
    echo "${PW_56}" | grep -E '[a-zA-Z0-9!@#$%^&*()_+=;.,~/-]{8,}'
    CHECK_RESULT $? 0 0 "log message: pwmake 56 generated invalid password"
    PW_128=$(pwmake 128)
    CHECK_RESULT $? 0 0 "log message: Failed to run command: pwmake 128 (medium entropy)"
    echo "${PW_128}" | grep -E '[a-zA-Z0-9!@#$%^&*()_+=;.,~/-]{8,}'
    CHECK_RESULT $? 0 0 "log message: pwmake 128 generated invalid password"
    PW_256=$(pwmake 256)
    CHECK_RESULT $? 0 0 "log message: Failed to run command: pwmake 256 (high entropy)"
    echo "${PW_256}" | grep -E '[a-zA-Z0-9!@#$%^&*()_+=;.,~/-]{8,}'
    CHECK_RESULT $? 0 0 "log message: pwmake 256 generated invalid password"
    # Verify password generation with invalid entropy values (above maximum) - pwmake adjusts to maximum
    PW_512=$(pwmake 512)
    CHECK_RESULT $? 0 0 "log message: Failed to run command: pwmake 512 (above maximum)"
    echo "${PW_512}" | grep -E '[a-zA-Z0-9!@#$%^&*()_+=;.,~/-]{8,}'
    CHECK_RESULT $? 0 0 "log message: pwmake 512 generated invalid password"
    # Verify generated password strength using pwscore
    PW_56=$(pwmake 56) && echo "${PW_56}" | pwscore 2>&1 | grep -E "^[0-9]+$"
    CHECK_RESULT $? 0 0 "log message: Failed to score pwmake 56 generated password"
    PW_128=$(pwmake 128) && echo "${PW_128}" | pwscore 2>&1 | grep -E "^[0-9]+$"
    CHECK_RESULT $? 0 0 "log message: Failed to score pwmake 128 generated password"
    PW_256=$(pwmake 256) && echo "${PW_256}" | pwscore 2>&1 | grep -E "^[0-9]+$"
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
