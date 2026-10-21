#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yangxi
# @Contact   :   735811396@qq.com
# @Date      :   2025/10/20
# @License   :   Mulan PSL v2
# @Desc      :   Test nscd.socket restart
# #############################################
# shellcheck disable=SC2119
source "${OET_PATH}"/testcases/function-test/pkgs-test/common/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL nscd
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    test_execution nscd.socket
    systemctl start nscd.socket
    LOG_INFO "Test nscd.socket dependencies"
    systemctl list-dependencies nscd.socket 2>/dev/null | grep -q "nscd.service" || \
    systemctl list-dependencies nscd.socket 2>/dev/null | grep -q "nscd" || \
    systemctl cat nscd.socket | grep -q "nscd.service"
    CHECK_RESULT $? 0 0 "nscd.socket should be related to nscd.service"
    LOG_INFO "Test nscd.socket listening state"
    systemctl is-active nscd.socket | grep -w "active"
    CHECK_RESULT $? 0 0 "nscd.socket should be in active state"
    LOG_INFO "Check nscd.socket listening"
    ss -lpn | grep -q nscd || \
    ls -la /var/run/nscd/socket 2>/dev/null && echo "socket file exists"
    CHECK_RESULT $? 0 0 "nscd.socket should be listening or have socket file"
    LOG_INFO "Test nscd.socket functionality after restart"
    systemctl restart nscd.socket
    CHECK_RESULT $? 0 0 "Failed to restart nscd.socket"
    sleep 2
    systemctl status nscd.socket | grep -q "Active: active"
    CHECK_RESULT $? 0 0 "nscd.socket should be active after restart"
    LOG_INFO "Check nscd socket file"
    test -S /var/run/nscd/socket
    CHECK_RESULT $? 0 0 "nscd socket file should exist after restart"
    LOG_INFO "Test nscd socket connectivity"
    getent hosts localhost >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "Basic name service should work with nscd socket"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    systemctl stop nscd.socket
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
