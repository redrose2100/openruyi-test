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
# @Date      :   2022/06/30
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of rsyslog
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if grep docker /proc/1/cgroup; then
        LOG_INFO "The current environment is Docker."
        exit 0
    fi
    DNF_INSTALL rsyslog
    systemctl start rsyslog
    old_id=$(pgrep rsyslog)
    old_timezone=$(timedatectl | grep "Local time" | awk '{print $6}')
    old_zone=$(timedatectl | grep "Time zone" | awk '{print $3}')
    rm -rf /etc/localtime
    cp -f /var/log/messages /var/log/messages.bak
    echo "" >/var/log/messages
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ln -sf /usr/share/zoneinfo/NZ /etc/localtime
    CHECK_RESULT $? 0 0 "Failed to execute cp"
    date | grep "$old_timezone"
    CHECK_RESULT $? 0 1 "Time zone changed"
    SLEEP_WAIT 900
    pgrep rsyslog | grep "$old_id"
    CHECK_RESULT $? 0 1 "Pid not changed"
    date | grep -i NZ
    CHECK_RESULT $? 0 0 "Time zone not changed"
    grep "timezone changed" /var/log/messages
    CHECK_RESULT $? 0 0 "/var/log/messages not logged"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    if grep docker /proc/1/cgroup; then
        LOG_INFO "The current environment is Docker."
        exit 0
    fi
    rm -rf /etc/localtime
    timedatectl set-timezone "$old_zone"
    mv -f /var/log/messages.bak /var/log/messages
    systemctl restart rsyslog
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
