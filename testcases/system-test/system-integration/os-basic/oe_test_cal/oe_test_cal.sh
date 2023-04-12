#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   deepin12
# @Contact   :   chenyia@uniontech.com
# @Date      :   2023-04-12
# @License   :   Mulan PSL v2
# @Desc      :   Command test-cal
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cal -1
    CHECK_RESULT $? 0 0 "displays one month failure"
    cal -3
    CHECK_RESULT $? 0 0 "displays three month failure"
    cal -n 2
    CHECK_RESULT $? 0 0  "displays the number of months that failed starting with the month of the date"
    cal -S
    CHECK_RESULT $? 0 0  "failed to display date ranges for multiple months"
    cal -s
    CHECK_RESULT $? 0 0  "sunday fails as the first day of the week"
    cal -m
    CHECK_RESULT $? 0 0  "monday fails as the first day of the week"
    cal -Y
    CHECK_RESULT $? 0 0  "show annual failure"
    cal -h|grep cal
    CHECK_RESULT $? 0 0  "check commmand usage fail"
    cal -V|grep util-linux
    CHECK_RESULT $? 0 0  "check version fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

