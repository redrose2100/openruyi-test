#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   saarloos
# @Contact   :   9090-90-90-9090@163.com
# @Date      :   2020-04-09
# @License   :   Mulan PSL v2
# @Desc      :   check basic commond lsof
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "lsof" 2>/dev/null || LOG_WARN "lsof not available, will use netstat as fallback"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    if command -v lsof &>/dev/null; then
        lsof -i
        CHECK_RESULT $? 0 0 "run lsof fail"

        lsof -i:22 | grep sshd
        CHECK_RESULT $? 0 0 "check lsof sshd fail"

        lsof --help 2>&1 | grep -i "Usage"
        CHECK_RESULT $? 0 0 "check lsof help fail"
    else
        netstat -tlnp
        CHECK_RESULT $? 0 0 "run netstat fail"

        netstat -tlnp | grep ':22' | grep sshd
        CHECK_RESULT $? 0 0 "check netstat sshd fail"

        netstat --help 2>&1 | grep -i "Usage"
        CHECK_RESULT $? 0 0 "check netstat help fail"
    fi

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE 2>/dev/null || true
    LOG_INFO "End to restore the test environment."
}

main "$@"
