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
    # Iterate over the journal files instead of relying on a glob that expands
    # to several arguments, and only back up the imjournal state when the
    # running rsyslog actually keeps one.
    for jf in /var/log/journal/*/system.journal /run/log/journal/*/system.journal \
        /run/log/imjournal.state /var/run/log/imjournal.state; do
        [ -f "${jf}" ] || continue
        cp -f "${jf}" "${jf}.bak"
    done
    for sf in /run/log/imjournal.state /var/run/log/imjournal.state; do
        [ -f "${sf}" ] && echo "" >"${sf}"
    done
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
    for jf in /var/log/journal/*/system.journal.bak /run/log/journal/*/system.journal.bak \
        /run/log/imjournal.state.bak /var/run/log/imjournal.state.bak; do
        [ -f "${jf}" ] || continue
        mv -f "${jf}" "${jf%.bak}"
    done
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
