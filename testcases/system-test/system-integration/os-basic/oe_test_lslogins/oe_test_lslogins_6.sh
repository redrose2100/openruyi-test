#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2025-5-26
# @License   :   Mulan PSL v2
# @Desc      :   command lslogins06
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    lslogins -o FAILED-TTY | grep -v "^$"
    CHECK_RESULT $? 0 0 "where did the login fail"
    lslogins -o HUSHED | uniq
    CHECK_RESULT $? 0 0 "user's hush settings"
    lslogins -o PWD-WARN | uniq | grep -v "^$"
    CHECK_RESULT $? 0 0 "days user is warned of password expiration"
    lslogins -o PWD-CHANGE | uniq
    CHECK_RESULT $? 0 0 "date of last password change"
    lslogins -o PWD-MIN | grep -v "^$"
    CHECK_RESULT $? 0 0 "number of days required between changes"
    lslogins -o PWD-MAX | uniq | grep -v "^$"
    CHECK_RESULT $? 0 0 "max number of days a password may remain unchanged"
    lslogins -o PWD-EXPIR | grep -v "^$"
    CHECK_RESULT $? 0 0 "password expiration date"
    lslogins -o CONTEXT | grep -v "^$"
    CHECK_RESULT $? 0 0 "the user's security context"
    lslogins -o PROC | uniq | grep -v "^$"
    CHECK_RESULT $? 0 0 "number of processes run by the user"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
