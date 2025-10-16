#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   wenjun
#@Contact       :   1009065695@qq.com
#@Date          :   2025-09-11
#@License       :   Mulan PSL v2
#@Desc          :   oeAware embedded test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "oeAware-manager" 2
    P_SSH_CMD --node 2 --cmd "dnf install -y kernel-rt"
    REMOTE_REBOOT 2 300
    P_SSH_CMD --node 2 --cmd "systemctl restart oeaware;
systemctl enable oeaware;
cp /etc/oeAware/plugin/realtime_tune.yaml /etc/oeAware/plugin/realtime_tune.yaml_bak"
    value_old=$(P_SSH_CMD --node 2 --cmd "cat /proc/sys/kernel/timer_migration")
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    P_SSH_CMD --node 2 --cmd "oeawarectl -e realtime_tune" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
    P_SSH_CMD --node 2 --cmd "cat /proc/sys/kernel/timer_migration | grep '^0'"
    CHECK_RESULT $? 0 0 "Check migration on failed."
    P_SSH_CMD --node 2 --cmd "oeawarectl -d realtime_tune"
    P_SSH_CMD --node 2 --cmd "sed -i 's/migration:.*/migration: on/' /etc/oeAware/plugin/realtime_tune.yaml;
oeawarectl -e realtime_tune"
    value_cur=$(P_SSH_CMD --node 2 --cmd "cat /proc/sys/kernel/timer_migration")
    test "${value_old}" = "${value_cur}"
    CHECK_RESULT $? 0 0 "Check migration off failed."
    P_SSH_CMD --node 2 --cmd "oeawarectl -d realtime_tune"
    P_SSH_CMD --node 2 --cmd "echo > /var/log/oeAware/server.log;
sed -i 's/migration:.*/migration: ont/' /etc/oeAware/plugin/realtime_tune.yaml;
oeawarectl -e realtime_tune" | grep "Instance enabled failed, because read realtime_tune.yaml failed"
    CHECK_RESULT $? 0 0 "Check migration is exception value failed."
    P_SSH_CMD --node 2 --cmd "cat /var/log/oeAware/server.log" | grep "ERROR realtime_tune - Invalid timer.migration value: ont"
    CHECK_RESULT $? 0 0 "Check migration is exception value failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    P_SSH_CMD --node 2 --cmd "mv -f /etc/oeAware/plugin/realtime_tune.yaml_bak /etc/oeAware/plugin/realtime_tune.yaml;rpm -e kernel-rt"
    DNF_REMOVE 2 "$@"
    REMOTE_REBOOT 2 300
    LOG_INFO "End to restore the test environment."
}

main "$@"
