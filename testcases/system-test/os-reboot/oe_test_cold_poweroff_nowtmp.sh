#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2025/06/27
# @License   :   Mulan PSL v2
# @Desc      :   Don't write wtmp record
# #############################################

# shellcheck disable=SC1091
source "./common_reboot.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    build_env
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    if P_SSH_CMD --node 2 --cmd "systemctl status systemd-update-utmp.service | grep 'active'"; then
        LOG_INFO "systemd-update-utmp.service exist"
    else
        LOG_INFO "systemd-update-utmp.service dose not exist"
        P_SSH_CMD --node 2 --cmd "echo >/var/log/wtmp;date -s 2020-10-10;poweroff -d --no-wtmp & env LANG=en_US.UTF-8 date +'%a %h %d %H:%M' >/home/time.txt;"
        SLEEP_WAIT 90
        ping -c 3 "${NODE2_IPV4}" >/dev/null
        CHECK_RESULT $? 0 1 "The execution of the 'poweroff -d' command failed."
        ipmitool -H "${NODE2_BMC_IP}" -I lanplus -U "${NODE2_BMC_USER}" -P "${NODE2_BMC_PASSWORD}" power on
        CHECK_RESULT $? 0 0 "The execution of the 'power on' command failed."
        REMOTE_REBOOT_WAIT 2 120
        CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
        ipmitool -H "${NODE2_BMC_IP}" -I lanplus -U "${NODE2_BMC_USER}" -P "${NODE2_BMC_PASSWORD}" power status | grep "Chassis Power is on"
        CHECK_RESULT $? 0 0 "The startup execution failed."
        P_SSH_CMD --node 2 --cmd "last -f /var/log/wtmp >/home/wtmp.txt;grep -wf /home/time.txt /home/wtmp.txt"
        CHECK_RESULT $? 0 1 "The execution of the wtmp failed."
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    P_SSH_CMD --node 2 --cmd "echo > /var/log/wtmp;rm -rf /home/time.txt /home/wtmp.txt"
    clean_env "$@"
    LOG_INFO "End to restore the test environment."
}
main "$@"
