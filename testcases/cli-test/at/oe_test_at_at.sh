#! /usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2024-04-12
# @License   :   Mulan PSL v2
# @Desc      :   Command test-at
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "at"
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    at 15:30 -f /usr/bin/ls
    CHECK_RESULT $? 0 0 "description failed to generate log files"
    atq |grep "15:30"
    CHECK_RESULT $? 0 0 "the scheduled task at 15:30 is not checked"
    echo "hello world" | at 14:30 -m
    CHECK_RESULT $? 0 0 "the scheduled task at 14:30 is not checked"
    atq |grep "14:30"
    CHECK_RESULT $? 0 0 "failed to enter using the file"
    echo "hello world" | at -q b 15:31
    CHECK_RESULT $? 0 0 "only the root user fails to be displayed"
    atq |grep "15:31"|grep b
    CHECK_RESULT $? 0 0 "the scheduled task at 15:31 and b is not checked"
    at -V
    CHECK_RESULT $? 0 0 "failed to filter tty login users. Procedure"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    export LANG=${OLD_LANG}
    DNF_REMOVE "$@"
    LOG_INFO "End to clean the test environment."
}

main "$@"


