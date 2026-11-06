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
# @Author    :   wangshan
# @Contact   :   wangshan@163.com
# @Date      :   2020-08-03
# @License   :   Mulan PSL v2
# @Desc      :   Systemctl initiates the service command and Rsyslogd is executing simultaneously
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "rsyslog inetutils"
    echo "local7.*  /var/log/test" >/etc/rsyslog.d/test.conf
    systemctl stop rsyslog
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl start rsyslog
    CHECK_RESULT $?
    [ -n "$(proc_pids_by_cmdline rsyslogd)" ]
    CHECK_RESULT $?
    # the second instance needs a dedicated pid file (-i), otherwise
    # rsyslogd 8.2510 aborts with error -3000 because the default pid
    # file is already held by the systemd-started instance.
    rsyslogd -i /tmp/rsyslogd_test.pid
    CHECK_RESULT $?
    CHECK_RESULT "$(proc_pids_by_cmdline rsyslogd | wc -l)" 2
    logger -p local7.error 'test' && sleep 1
    CHECK_RESULT "$(cat /var/log/test | wc -l)" 2
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    proc_kill_pids $(proc_pids_by_cmdline rsyslogd)
    rm -rf /etc/rsyslog.d/test.conf /var/log/test /tmp/rsyslogd_test.pid
    systemctl start rsyslog
    LOG_INFO "End to restore the test environment."
}
main "$@"
