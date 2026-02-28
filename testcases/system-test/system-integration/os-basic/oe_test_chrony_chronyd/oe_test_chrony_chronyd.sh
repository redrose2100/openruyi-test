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
# @Desc      :   Use Chrony test
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

IS_ENABLE=0
IS_ACTIVE=0

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "chrony"
    LOG_INFO "End to prepare the test environment."
    systemctl is-enabled chronyd && IS_ENABLE=1
    systemctl is-active chronyd && IS_ACTIVE=1
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl enable chronyd --now
    systemctl status chronyd
    CHECK_RESULT $? 0 0 "chronyd not running"
    systemctl is-enabled chronyd
    CHECK_RESULT $? 0 0 "chronyd not enabled"

    test -f /etc/chrony.conf
    CHECK_RESULT $? 0 0 "/etc/chrony.conf not exists"

    chronyc sources | grep -i "MS Name/IP address"
    CHECK_RESULT $? 0 0 "chronyc cources failed"
    chronyc tracking | grep -E "Reference ID|Stratum"
    CHECK_RESULT $? 0 0 "chronyc tracking failed"
    chronyc sourcestats | grep -i "Name/IP address"
    CHECK_RESULT $? 0 0 "chronyc sourcestats failed"
    echo "sources" | chronyc | grep -i "MS Name/IP address"
    CHECK_RESULT $? 0 0 "read from pipe failed"

    chronyc invalid_command >/dev/null 2>&1
    CHECK_RESULT $? 0 1 "failed with invalid command"

    systemctl stop chronyd
    systemctl status chronyd
    CHECK_RESULT $? 0 1 "status should be dead"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE "$@"

    LOG_INFO "Restore chronyd status:"
    LOG_INFO "is_enable: $IS_ENABLE, is_active: $IS_ACTIVE"

    if [[ "$IS_ENABLE" -eq 1 ]]; then
        systemctl enable chronyd
    else
        systemctl disable chronyd
    fi

    if [[ "$IS_ACTIVE" -eq 1 ]]; then
        systemctl start chronyd
    else
        systemctl stop chronyd
    fi

    LOG_INFO "End to restore the test environment."
}

main "$@"
