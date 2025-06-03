#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zengcongwei
# @Contact   :   735811396@qq.com
# @Date      :   2020/12/29
# @License   :   Mulan PSL v2
# @Desc      :   Test auth.socket restart
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "authd net-tools nmap-ncat"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    test_execution auth.socket
    systemctl start auth.socket
    systemctl reload auth.socket 2>&1 | grep "Job type reload is not applicable for unit auth.socket"
    CHECK_RESULT $?
    systemctl status auth.socket | grep "Active: active"
    CHECK_RESULT $?
    ss -tunlp | grep ":113"
    CHECK_RESULT $? 0 0 "Auth service is not listening on default port 113"
    pgrep -f "authd"
    CHECK_RESULT $? 0 0 "Auth service process is not running"
    systemctl show auth.socket | grep -E "Listen|Socke"
    CHECK_RESULT $? 0 0 "Auth socket configuration error"
    systemctl show auth.socket --property=LoadState | grep "loaded"
    CHECK_RESULT $? 0 0 "Auth socket load state error"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
