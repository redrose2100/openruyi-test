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
#@Date          :   2026-06-09
#@License       :   Mulan PSL v2
#@Desc          :   Test case for sulogin command
#####################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL util-linux
    rm -rf /tmp/sulogin-*
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    LOG_INFO "Check sulogin binary existence"
    [ -f /usr/sbin/sulogin ]
    CHECK_RESULT $? 0 0 "sulogin binary not found at expected path /usr/sbin/sulogin"

    LOG_INFO "Test short help option -h"
    sulogin -h | grep "显示此帮助" > /tmp/sulogin-help.out
    CHECK_RESULT $? 0 0 "sulogin -h help option test failed"

    LOG_INFO "Test long help option --help"
    sulogin --help | grep "显示此帮助" >> /tmp/sulogin-help.out
    CHECK_RESULT $? 0 0 "sulogin --help option test failed"

    LOG_INFO "Test short version option -V"
    sulogin -V | grep -E "(sulogin|version|Version)" > /tmp/sulogin-version.out
    CHECK_RESULT $? 0 0 "sulogin -V version option test failed"

    LOG_INFO "Test long version option --version"
    sulogin --version | grep -E "(sulogin|version|Version)" >> /tmp/sulogin-version.out
    CHECK_RESULT $? 0 0 "sulogin --version option test failed"

    LOG_INFO "Test timeout option -t"
    timeout 5 sulogin -t 1 < /dev/null > /dev/null 2>&1
    CHECK_RESULT $? 124 1 "sulogin -t option failed: process hung beyond expected timeout"

    LOG_INFO "Test -p login-shell short option"
    sulogin -p -t 1 < /dev/null > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "sulogin -p login-shell option is invalid"

    LOG_INFO "Test --login-shell long option"
    sulogin --login-shell -t 1 < /dev/null > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "sulogin --login-shell long option is invalid"

    LOG_INFO "Test -e force short option"
    sulogin -e -t 1 < /dev/null > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "sulogin -e force option is invalid"

    LOG_INFO "Test --force long option"
    sulogin --force -t 1 < /dev/null > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "sulogin --force long option is invalid"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/sulogin-*
    LOG_INFO "End to restore the test environment."
}

main "$@"
