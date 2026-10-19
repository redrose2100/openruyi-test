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
# @Desc      :   Scheduled task triggers restart
# #############################################

# shellcheck disable=SC1091
source "./common_reboot.sh"

function run_test() {
    LOG_INFO "Start to run test."
    P_SSH_CMD --node 2 --cmd "date -s '2020-10-11 03:59:00'"
    P_SSH_CMD --node 2 --cmd "cat >> /var/spool/cron/root <<EOF 
00 04 * * * /sbin/shutdown -r now & echo \\\$(env LANG=en_US.UTF-8 date +'\\%a \\%h \\%d \\%H:\\%M') >> time.txt
EOF"
    SLEEP_WAIT 60
    REMOTE_REBOOT_WAIT 2 120
    SLEEP_WAIT 10
    P_SSH_CMD --node 2 --cmd "last -f /var/log/wtmp >/tmp/wtmp.txt;grep -wf time.txt /tmp/wtmp.txt;echo > /var/log/wtmp;rm -rf time.txt /tmp/wtmp.txt;date -s '2020-10-10 03:59:00';"
    CHECK_RESULT $? 0 0 "The execution of the 'date -s' command failed."
    SLEEP_WAIT 90
    REMOTE_REBOOT_WAIT 2 120
    P_SSH_CMD --node 2 --cmd "last -f /var/log/wtmp >/tmp/wtmp.txt;grep -wf time.txt /tmp/wtmp.txt;"
    CHECK_RESULT $? 0 0 "The execution of the wtmp failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    P_SSH_CMD --node 2 --cmd "rm -rf time.txt /tmp/wtmp.txt;crontab -r"
    LOG_INFO "End to restore the test environment."
}
main "$@"
