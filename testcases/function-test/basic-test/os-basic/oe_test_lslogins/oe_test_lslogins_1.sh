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
# @Date      :   2024-7-8
# @License   :   Mulan PSL v2
# @Desc      :   command lslogins
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    useradd test1
    echo test1:deepin12#$ | chpasswd
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    lslogins -h | grep -A20 Options
    CHECK_RESULT $? 0 0 "display this help fail"
    lslogins -V | grep lslogins
    CHECK_RESULT $? 0 0 "display version fail"
    lslogins -u test1 | grep test1
    CHECK_RESULT $? 0 0 "display user accounts fail"
    lslogins -a | grep -A10 PWD-CHANGE	
    CHECK_RESULT $? 0 0 "display data about the date of last password change and the account expiration date fail"
    lslogins -c | grep -A10 USER
    CHECK_RESULT $? 0 0 "use a colon instead of a newline fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    export LANG=${OLD_LANG}
    userdel -rf test1
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
