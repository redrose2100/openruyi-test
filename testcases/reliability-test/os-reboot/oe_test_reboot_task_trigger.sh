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

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    # The openRuyi image does not preinstall cronie: /var/spool/cron does not exist and the
    # crontab command is missing, so the scheduled job cannot be registered and the case
    # fails later on the grep with rc=2 (observed: '/var/spool/cron/root: No such file or
    # directory' and 'crontab: command not found').
    DNF_INSTALL "cronie" 2
    P_SSH_CMD --node 2 --cmd "mkdir -p /var/spool/cron; systemctl enable --now crond; systemctl restart crond"
    P_SSH_CMD --node 2 --cmd "systemctl is-active crond"
    CHECK_RESULT $? 0 0 "Failed to start crond service on node 2."
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    P_SSH_CMD --node 2 --cmd "date -s '2020-10-11 03:59:00'"
    P_SSH_CMD --node 2 --cmd "cat > /var/spool/cron/root <<EOF
00 04 * * * /sbin/shutdown -r now & echo \\\$(env LANG=en_US.UTF-8 date +'\\%a \\%h \\%d \\%H:\\%M') >> /root/time.txt
EOF
chmod 600 /var/spool/cron/root"
    CHECK_RESULT $? 0 0 "Failed to register the cron job on node 2."
    # Confirm crond actually picked the job up, otherwise the reboot will never be triggered.
    P_SSH_CMD --node 2 --cmd "crontab -l | grep -q 'shutdown -r now'"
    CHECK_RESULT $? 0 0 "The cron job was not registered on node 2."
    SLEEP_WAIT 60
    REMOTE_REBOOT_WAIT 2 120
    SLEEP_WAIT 10
    # time.txt is produced by the cron job in root's home directory, always read it through
    # an absolute path so the result does not depend on the cwd of the ssh session.
    P_SSH_CMD --node 2 --cmd "last -f /var/log/wtmp >/tmp/wtmp.txt;grep -wf /root/time.txt /tmp/wtmp.txt;echo > /var/log/wtmp;rm -rf /root/time.txt /tmp/wtmp.txt;date -s '2020-10-10 03:59:00';"
    CHECK_RESULT $? 0 0 "The execution of the 'date -s' command failed."
    SLEEP_WAIT 90
    REMOTE_REBOOT_WAIT 2 120
    P_SSH_CMD --node 2 --cmd "last -f /var/log/wtmp >/tmp/wtmp.txt;grep -wf /root/time.txt /tmp/wtmp.txt;"
    CHECK_RESULT $? 0 0 "The execution of the wtmp failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    # The case moves the node clock to 2020, restore it so later cases do not fail on
    # timestamp / certificate validation.
    P_SSH_CMD --node 2 --cmd "rm -rf /root/time.txt /tmp/wtmp.txt;crontab -r >/dev/null 2>&1;rm -f /var/spool/cron/root;date -s \"$(date '+%Y-%m-%d %H:%M:%S')\""
    DNF_REMOVE 2
    LOG_INFO "End to restore the test environment."
}
main "$@"
