#!/usr/bin/bash
# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liangdong
# @Contact   :   liangdong47@h-partners.com
# @Date      :   2024/07/27
# @License   :   Mulan PSL v2
# @Desc      :   构造/var/run/sshd.init.pid文件异常，然后重启sshd服务正常
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

sshd_pid_dir1="/var/run/sshd.pid"
sshd_pid_dir2="/var/run/sshd.init.pid"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL openssh-server
    CHECK_RESULT $? 0 0

}

function run_test() {
    LOG_INFO "Start to run test."
    if test -f $sshd_pid_dir1; then
        echo > $sshd_pid_dir1
    else
        echo > $sshd_pid_dir2
    fi
    systemctl restart sshd
    CHECK_RESULT $? 0 0 "sshd restart failed"
    systemctl status sshd
    CHECK_RESULT $? 0 0 "sshd not active after restart"
    pid=$(pgrep -f "/usr/sbin/sshd" | head -n 1)
    echo "${pid}"
    CHECK_RESULT $? 0 0 "failed to get sshd pid"
    if test -f $sshd_pid_dir1; then
        pid1=$(awk '{print $1}' "$sshd_pid_dir1" | head -n 1)
        echo "${pid1}"
    else
        pid1=$(awk '{print $1}' "$sshd_pid_dir2" | head -n 1)
        echo "${pid1}"
    fi
    CHECK_RESULT $? 0 0 "failed to read pid file"
    [ "${pid}" = "${pid1}" ]
    CHECK_RESULT $? 0 0 "PID mismatch: running pid=${pid}, pidfile=${pid1}"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f "$sshd_pid_dir1" "$sshd_pid_dir2"
    systemctl restart sshd
    LOG_INFO "End to restore the test environment."
}

main "$@"
