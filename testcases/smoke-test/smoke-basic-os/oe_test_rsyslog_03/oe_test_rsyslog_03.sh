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
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2022/06/27
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of rsyslog
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL rsyslog
    systemctl start rsyslog
    if [ -d /var/log/journal ]; then
        cp -f /var/log/journal/*/system.journal /var/log/journal/*/system.journal.bak
        cp -f /var/run/log/imjournal.state /var/run/log/imjournal.state.bak
        echo "" >/var/run/log/imjournal.state
    else
        cp -f /run/log/journal/*/system.journal /run/log/journal/*/system.journal.bak
        cp -f /run/log/imjournal.state /run/log/imjournal.state.bak
        echo "" >/run/log/imjournal.state
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl restart systemd-journald
    CHECK_RESULT $? 0 0 "Systemd-journald not started"
    systemctl restart rsyslog
    CHECK_RESULT $? 0 0 "Rsyslog not started"
    if [ -d /var/log/journal ]; then
        find /var/log/journal/ -name system.journal -type f
        CHECK_RESULT $? 0 0 "Failed to find system.journal"
        grep "[0-9]" /var/run/log/imjournal.state
    else
        find /run/log/journal/ -name system.journal -type f
        CHECK_RESULT $? 0 0 "Failed to find system.journal"
        grep "[0-9]" /run/log/imjournal.state
    fi
    CHECK_RESULT $? 0 0 "File has no content"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    if [ -d /var/log/journal ]; then
        mv -f /var/log/journal/*/system.journal.bak /var/log/journal/*/system.journal
        mv -f /var/run/log/imjournal.state.bak /var/run/log/imjournal.state
    else
        mv -f /run/log/journal/*/system.journal.bak /run/log/journal/*/system.journal
        mv -f /run/log/imjournal.state.bak /run/log/imjournal.state
    fi
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
