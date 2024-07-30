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
# @Date      :   2024-04-9
# @License   :   Mulan PSL v2
# @Desc      :   Command test-ausyscall
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    ausyscall list --dump
    CHECK_RESULT $? 0 0 "failed to view all SYSCALL options supported by auditd"
    ausyscall  list
    CHECK_RESULT $? 0 0 "failed to list the system calls supported by the current system"
    ausyscall  100
    CHECK_RESULT $? 0 0 "100 command execution failed"
    ausyscall --exact 1
    CHECK_RESULT $? 0 0 "exact command execution failed"
    ausyscall open | grep open
    CHECK_RESULT $? 0 0 "retrieval failed open"
    ausyscall read | grep read
    CHECK_RESULT $? 0 0 "retrieval failed read"
    ausyscall write |grep write
    CHECK_RESULT $? 0 0 "retrieval failed write"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    export LANG=${OLD_LANG}
    LOG_INFO "End to clean the test environment."
}

main "$@"

