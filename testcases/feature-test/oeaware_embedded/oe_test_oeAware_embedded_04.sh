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
# shellcheck disable=SC2016

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "oeAware-manager" 2
    P_SSH_CMD --node 2 --cmd "dnf install -y kernel-rt"
    REMOTE_REBOOT 2 300
    P_SSH_CMD --node 2 --cmd "systemctl restart oeaware;
systemctl enable oeaware;
cp /etc/oeAware/plugin/realtime_tune.yaml /etc/oeAware/plugin/realtime_tune.yaml_bak"
    echo 'for pid in $(pgrep rcu);do echo "PID $pid ($(ps -p $pid -o comm=)) affinity: $(taskset -p $pid)";done' > test.sh
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    P_SSH_CMD --node 2 --cmd "oeawarectl -e realtime_tune" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
    REMOTE_REBOOT 2 300
    SSH_SCP test.sh "${NODE2_USER}"@"${NODE2_IPV4}":~ "${NODE2_PASSWORD}"
    P_SSH_CMD --node 2 --cmd "pwd;cat /proc/cmdline;sh test.sh" | grep -E "ffffffffffffffffffffffffffffffe7|ffffffffffe7"
    CHECK_RESULT $? 0 0 "Check rcu_nocbs on failed."
    P_SSH_CMD --node 2 --cmd "oeawarectl -d realtime_tune"
    P_SSH_CMD --node 2 --cmd "\cp -f /etc/oeAware/plugin/realtime_tune.yaml_bak /etc/oeAware/plugin/realtime_tune.yaml;
sed -i 's/isolcpus:.*/isolcpus: off/' /etc/oeAware/plugin/realtime_tune.yaml;
sed -i 's/nohz_full:.*/nohz_full: off/' /etc/oeAware/plugin/realtime_tune.yaml;
sed -i 's/rcu_nocbs:.*/rcu_nocbs: off/' /etc/oeAware/plugin/realtime_tune.yaml;
sed -i 's/irqaffinity:.*/irqaffinity: off/' /etc/oeAware/plugin/realtime_tune.yaml;
oeawarectl -e realtime_tune" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
    REMOTE_REBOOT 2 300
    P_SSH_CMD --node 2 --cmd "cat /proc/cmdline;sh test.sh" | grep -E "ffffffffffffffffffffffffffffffe7|ffffffffffe7"
    CHECK_RESULT $? 1 0 "Check rcu_nocbs off failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    P_SSH_CMD --node 2 --cmd "oeawarectl -d realtime_tune"
    P_SSH_CMD --node 2 --cmd "rm -rf test.sh;mv -f /etc/oeAware/plugin/realtime_tune.yaml_bak /etc/oeAware/plugin/realtime_tune.yaml;rpm -e kernel-rt"
    DNF_REMOVE 2 "$@"
    REMOTE_REBOOT 2 300
    LOG_INFO "End to restore the test environment."
}

main "$@"
