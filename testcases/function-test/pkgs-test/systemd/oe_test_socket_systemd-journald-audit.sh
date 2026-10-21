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
# @Author    :   zengcongwei
# @Contact   :   735811396@qq.com
# @Date      :   2020/12/29
# @License   :   Mulan PSL v2
# @Desc      :   Test systemd-journald-audit.socket restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    systemctl stop systemd-journald-audit.socket
    systemctl stop systemd-journald.socket
    systemctl stop systemd-journald-dev-log.socket
    systemctl stop systemd-journald.service
    log_time=$(date '+%Y-%m-%d %T')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl restart systemd-journald-audit.socket
    CHECK_RESULT $? 0 0 "systemd-journald-audit.socket restart failed"
    SLEEP_WAIT 5
    systemctl status systemd-journald-audit.socket | grep "Active: active"
    CHECK_RESULT $? 0 0 "systemd-journald-audit.socket restart failed"
    systemctl stop systemd-journald-audit.socket
    CHECK_RESULT $? 0 0 "systemd-journald-audit.socket stop failed"
    SLEEP_WAIT 5
    systemctl status systemd-journald-audit.socket | grep "Active: inactive"
    CHECK_RESULT $? 0 0 "systemd-journald-audit.socket stop failed"
    systemctl stop systemd-journald-audit.socket
    systemctl stop systemd-journald.socket
    systemctl stop systemd-journald-dev-log.socket
    systemctl stop systemd-journald.service
    systemctl start systemd-journald-audit.socket
    CHECK_RESULT $? 0 0 "systemd-journald-audit.socket start failed"
    SLEEP_WAIT 5
    systemctl status systemd-journald-audit.socket | grep "Active: active"
    CHECK_RESULT $? 0 0 "systemd-journald-audit.socket start failed"
    test_enabled systemd-journald-audit.socket
    journalctl --since "${log_time}" -u systemd-journald-audit.socket | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARNING"
    CHECK_RESULT $? 0 1 "There is an error message for the log of systemd-journald-audit.socket"
    test_reload systemd-journald-audit.socket
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl start systemd-journald-audit.socket
    systemctl start systemd-journald.socket
    systemctl start systemd-journald-dev-log.socket
    systemctl start systemd-journald.service
    systemctl stop systemd-journald-audit.socket
    LOG_INFO "End to restore the test environment."
}

main "$@"
