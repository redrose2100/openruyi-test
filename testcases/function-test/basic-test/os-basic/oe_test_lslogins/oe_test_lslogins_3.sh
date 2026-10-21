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
# @Date      :   2024-7-31
# @License   :   Mulan PSL v2
# @Desc      :   command lslogins03
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
    lslogins -n | grep USER
    CHECK_RESULT $? 0 0 "display each piece of information on a new line fail"
    lslogins -p | grep -A10 PWD
    CHECK_RESULT $? 0 0 "display information related to login by password fail"
    lslogins -r | grep -A10 USER
    CHECK_RESULT $? 0 0 "raw output with no columnation fail"
    lslogins -s | grep -A10 USER
    CHECK_RESULT $? 0 0 "show system accounts fail"
    lslogins -Z | grep -A10 USER
    CHECK_RESULT $? 0 0 "display SELinux contexts fail"
    lslogins -z | grep USER
    CHECK_RESULT $? 0 0 "delimit user entries with a nul character fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
