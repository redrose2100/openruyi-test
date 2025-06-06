#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2025/6/5
# @License   :   Mulan PSL v2
# @Desc      :   Test low-memory-monitor.service restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL low-memory-monitor 2
    P_SSH_CMD --cmd "cp -f /etc/default/grub /root/grub-bak;sed -i '/CMDLINE_LINUX/s/\"$/ psi=1\"/' /etc/default/grub;grub2-mkconfig -o $(find / -name grub.cfg)" --node 2
    REMOTE_REBOOT 2 30
    service=low-memory-monitor.service
    log_time=$(P_SSH_CMD --cmd "date '+%Y-%m-%d %T'" --node 2)
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    P_SSH_CMD --node 2 --cmd "systemctl restart ${service}"
    SLEEP_WAIT 5
    P_SSH_CMD --node 2 --cmd "systemctl status ${service} | grep 'Active: active'"
    CHECK_RESULT $? 0 0 "${service} restart failed"
    P_SSH_CMD --node 2 --cmd "systemctl stop ${service}"
    SLEEP_WAIT 5
    P_SSH_CMD --node 2 --cmd "systemctl status ${service} | grep 'Active: inactive'"
    CHECK_RESULT $? 0 0 "${service} stop failed"
    P_SSH_CMD --node 2 --cmd "systemctl start ${service}"
    SLEEP_WAIT 5
    P_SSH_CMD --node 2 --cmd "systemctl status ${service} | grep 'Active: active'"
    CHECK_RESULT $? 0 0 "${service} start failed"
    P_SSH_CMD --node 2 --cmd "systemctl enable ${service}"
    P_SSH_CMD --node 2 --cmd "find /etc/systemd/system/basic.target.wants/${service}"
    CHECK_RESULT $? 0 0 "${service} enable failed"
    P_SSH_CMD --node 2 --cmd "systemctl disable ${service}"
    P_SSH_CMD --node 2 --cmd "test ! -f /etc/systemd/system/basic.target.wants/${service}"
    CHECK_RESULT $? 0 0 "${service} disable failed"
    P_SSH_CMD --node 2 --cmd "systemctl reload ${service} 2>&1 | grep 'Job type reload is not applicable'"
    CHECK_RESULT $? 0 0 "Job type reload is not applicable for unit ${service}"
    P_SSH_CMD --node 2 --cmd "systemctl status ${service} | grep 'Active: active'"
    CHECK_RESULT $? 0 0 "Check ${service} status failed"
    P_SSH_CMD --node 2 --cmd "test 0 -eq \$(journalctl --since '${log_time}' -u ${service} | grep -icE 'fail|error')"
    CHECK_RESULT $? 0 0 "There is an error message for the log of ${service}"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    P_SSH_CMD --cmd "cp -f /root/grub-bak /etc/default/grub;grub2-mkconfig -o $(find / -name grub.cfg);rm -rf /root/grub-bak" --node 2
    REMOTE_REBOOT 2 30
    DNF_REMOVE "$@" 2
    LOG_INFO "End to restore the test environment."
}

main "$@"
