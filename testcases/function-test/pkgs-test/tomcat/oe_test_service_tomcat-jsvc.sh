#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test tomcat-jsvc.service restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL tomcat-jsvc
    log_time=$(date '+%Y-%m-%d %T')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl start tomcat-jsvc.service
    CHECK_RESULT $? 0 0 "tomcat-jsvc.service start failed"
    if [ "$(uname -m)" == "riscv64" ]; then
        SLEEP_WAIT 300
    else
        SLEEP_WAIT 30
    fi
    systemctl status tomcat-jsvc.service | grep "Active: active"
    CHECK_RESULT $? 0 0 "tomcat-jsvc.service start failed"
    systemctl stop tomcat-jsvc.service
    CHECK_RESULT $? 0 0 "tomcat-jsvc.service stop failed"
    SLEEP_WAIT 5
    systemctl status tomcat-jsvc.service | grep "Active: inactive"
    CHECK_RESULT $? 0 0 "tomcat-jsvc.service stop failed"
    systemctl restart tomcat-jsvc.service
    CHECK_RESULT $? 0 0 "tomcat-jsvc.service restart failed"
    SLEEP_WAIT 5
    systemctl status tomcat-jsvc.service | grep "Active: active"
    CHECK_RESULT $? 0 0 "tomcat-jsvc.service restart failed"
    test_enabled tomcat-jsvc.service
    journalctl --since "${log_time}" -u tomcat-jsvc.service | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARNING"
    CHECK_RESULT $? 0 1 "There is an error message for the log of tomcat-jsvc.service"
    test_reload tomcat-jsvc.service
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop tomcat-jsvc.service
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
