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
# shellcheck disable=SC2034

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    EXECUTE_T="60m"
    DNF_INSTALL "oeAware-manager" 2
    P_SSH_CMD --node 2 --cmd "dnf install -y kernel-rt"
    REMOTE_REBOOT 2 300
    P_SSH_CMD --node 2 --cmd "uname -r"
    P_SSH_CMD --node 2 --cmd "systemctl restart oeaware;
systemctl enable oeaware;
cp /etc/oeAware/plugin/realtime_tune.yaml /etc/oeAware/plugin/realtime_tune.yaml_bak"
    cpus=$(P_SSH_CMD --node 2 --cmd "lscpu | grep NUMA | tail -n 1 | awk -F'-' '{print \$NF}'")
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    P_SSH_CMD --node 2 --cmd "sed -i 's/range:.*/range: \"3\"/' /etc/oeAware/plugin/realtime_tune.yaml;
oeawarectl -e realtime_tune" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
    SLEEP_WAIT 30
    REMOTE_REBOOT 2 300
    P_SSH_CMD --node 2 --cmd "cat /proc/cmdline"
    P_SSH_CMD --node 2 --cmd "cat /proc/cmdline" | grep -z "irqaffinity=0-2,4-${cpus} isolcpus=3 nohz_full=3 rcu_nocbs=3" 
    CHECK_RESULT $? 0 0 "Check single cpu isolation failed."
    P_SSH_CMD --node 2 --cmd "oeawarectl -d realtime_tune" | grep "Instance disabled successfully"
    CHECK_RESULT $? 0 0 "Check realtime_tune disable failed."
    P_SSH_CMD --node 2 --cmd "sed -i 's/range:.*/range: \"3,5,9\"/' /etc/oeAware/plugin/realtime_tune.yaml;
oeawarectl -e realtime_tune" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
    REMOTE_REBOOT 2 300
    P_SSH_CMD --node 2 --cmd "cat /proc/cmdline"
    P_SSH_CMD --node 2 --cmd "cat /proc/cmdline" | grep -z "irqaffinity=0-2,4,6-8,10-${cpus} isolcpus=3,5,9 nohz_full=3,5,9 rcu_nocbs=3,5,9" 
    CHECK_RESULT $? 0 0 "Check multiple cpu isolation failed."
    P_SSH_CMD --node 2 --cmd "oeawarectl -d realtime_tune"
    P_SSH_CMD --node 2 --cmd "sed -i 's/range:.*/range: \"3-5,9-12\"/' /etc/oeAware/plugin/realtime_tune.yaml;
oeawarectl -e realtime_tune" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
    REMOTE_REBOOT 2 300
    P_SSH_CMD --node 2 --cmd "cat /proc/cmdline"
    P_SSH_CMD --node 2 --cmd "cat /proc/cmdline" | grep -z "irqaffinity=0-2,6-8,13-${cpus} isolcpus=3-5,9-12 nohz_full=3-5,9-12 rcu_nocbs=3-5,9-12"
    CHECK_RESULT $? 0 0 "Check multiple cpu isolation failed."
    P_SSH_CMD --node 2 --cmd "oeawarectl -d realtime_tune"
    P_SSH_CMD --node 2 --cmd "sed -i 's/range:.*/range: \"0\"/' /etc/oeAware/plugin/realtime_tune.yaml;
oeawarectl -e realtime_tune" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
    REMOTE_REBOOT 2 300
    P_SSH_CMD --node 2 --cmd "cat /proc/cmdline" | grep -z "isolcpus"
    CHECK_RESULT $? 1 0 "Check cpu0 isolation failed."
    P_SSH_CMD --node 2 --cmd "oeawarectl -d realtime_tune"
    P_SSH_CMD --node 2 --cmd "sed -i 's/range:.*/range: \"1000\"/' /etc/oeAware/plugin/realtime_tune.yaml;
oeawarectl -e realtime_tune"
    CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
    P_SSH_CMD --node 2 --cmd "\cp -f /etc/oeAware/plugin/realtime_tune.yaml_bak /etc/oeAware/plugin/realtime_tune.yaml;
sed -i 's/isolcpus:.*/isolcpus: off/' /etc/oeAware/plugin/realtime_tune.yaml;
sed -i 's/nohz_full:.*/nohz_full: off/' /etc/oeAware/plugin/realtime_tune.yaml;
sed -i 's/rcu_nocbs:.*/rcu_nocbs: off/' /etc/oeAware/plugin/realtime_tune.yaml;
sed -i 's/irqaffinity:.*/irqaffinity: off/' /etc/oeAware/plugin/realtime_tune.yaml;
oeawarectl -e realtime_tune" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
    REMOTE_REBOOT 2 300
    P_SSH_CMD --node 2 --cmd "cat /proc/cmdline" | grep -z "isolcpus=3-4"
    CHECK_RESULT $? 1 0 "Check cpu off failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    P_SSH_CMD --node 2 --cmd "oeawarectl -d realtime_tune"
    P_SSH_CMD --node 2 --cmd "mv -f /etc/oeAware/plugin/realtime_tune.yaml_bak /etc/oeAware/plugin/realtime_tune.yaml;rpm -e kernel-rt"
    DNF_REMOVE 2 "$@"
    REMOTE_REBOOT 2 300
    LOG_INFO "End to restore the test environment."
}

main "$@"
