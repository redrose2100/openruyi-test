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
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-4-9
# @License   :   Mulan PSL v2
# @Desc      :   Log View
# #############################################

# shellcheck disable=SC1091
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    rmMessage=1
    if [ -e /var/log/messages ]; then
        rmMessage=0
    fi
    rsyslog_was_active=0
    systemctl is-active rsyslog >/dev/null 2>&1 && rsyslog_was_active=1
    systemctl restart rsyslog 2>/dev/null || /etc/init.d/syslog restart 2>/dev/null || true
    sleep 2
    if [ ! -e /var/log/messages ]; then
        touch /var/log/messages
        logger "var_log test init"
        sleep 1
    fi
    logfile=/tmp/var_log_test_$$.log

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    ls /var/log
    CHECK_RESULT $? 0 0 "check /vat/log dir fail"
    tail -f /var/log/messages >${logfile} 2>&1 &
    row01=$(cat ${logfile} | wc -l)
    logger "var_log test trigger"
    SLEEP_WAIT 5
    row02=$(cat ${logfile} | wc -l)
    [ "${row01}" -le "${row02}" ]
    CHECK_RESULT $? 0 0 "check log message file line fail"

    cat /var/log/messages
    CHECK_RESULT $? 0 0 "check log message file fail"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    pid=$(ps -ef | grep "tail -f /var/log/messages" | grep -v grep | awk '{print $2}')
    kill -9 "${pid}" 2>/dev/null
    rm -rf ${logfile}
    if [ ${rmMessage} -eq 1 ]; then
        rm -rf /var/log/messages
    fi
    if [ ${rsyslog_was_active} -eq 0 ]; then
        systemctl stop rsyslog 2>/dev/null || /etc/init.d/syslog stop 2>/dev/null || true
    fi

    LOG_INFO "End to restore the test environment."
}

main "$@"
