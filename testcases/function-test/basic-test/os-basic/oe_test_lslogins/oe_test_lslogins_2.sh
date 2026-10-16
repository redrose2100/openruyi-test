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
# @Date      :   2024-7-19
# @License   :   Mulan PSL v2
# @Desc      :   command lslogins02
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
    lslogins -e | grep USER
    CHECK_RESULT $? 0 0 "output data in the format of NAME=VALUE fail"
    lslogins -f | grep -A10 FAILED-LOGIN
    CHECK_RESULT $? 0 0 "display data about the user's last failed login attempts fail"
    lslogins -G | grep -A10 SUPP-GROUPS
    CHECK_RESULT $? 0 0 "show information about supplementary groups fail"
    lslogins -L | grep -A10 LAST
    CHECK_RESULT $? 0 0 "display data containing information about the user's last login sessions fail"
    lslogins -l test1 | grep test1
    CHECK_RESULT $? 0 0 "only show data of users with a login specified fail" 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    export LANG=${OLD_LANG}
    userdel -rf test1
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
