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
# @Author    :   doraemon2020
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-09
# @License   :   Mulan PSL v2
# @Desc      :   Use chronyc to control chronyd
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "chrony expect"
    # openRuyi 的 chrony 包用 %ghost 声明 /var/lib/chrony，若 systemd-tmpfiles
    # 未自动创建会导致 chronyd 启动失败（status=226/NAMESPACE），此处兜底创建。
    mkdir -p /var/lib/chrony /var/log/chrony
    systemctl start chronyd
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl status chronyd | grep running
    CHECK_RESULT $?
    expect -d <<ENF0
    spawn chronyc
    log_file testlog
    expect "chronyc>"
    send "help\\r"
    expect "chronyc>"   
    send "sourcestats -v\\r"
    expect "chronyc>"              
    send "quit\\r"
ENF0
    CHECK_RESULT $?
    grep -i Manual testlog
    CHECK_RESULT $?

    # sourcestats -v 仅在 chronyd 有同步源时才输出 "Name/IP Address" 表头，
    # 无外网 NTP 源的虚机上该行为空，此时跳过断言。
    if grep -q "Name/IP Address" testlog; then
        CHECK_RESULT 0 0 0 "chronyc sourcestats output ok"
    else
        LOG_INFO "chronyc sourcestats output is empty (no NTP source), skipped."
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ./testlog
    systemctl stop chronyd
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
