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
cp /etc/oeAware/plugin/realtime_tune.yaml /etc/oeAware/plugin/realtime_tune.yaml_bak"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    P_SSH_CMD --node 2 --cmd "echo > /var/log/oeAware/server.log;
sed -i 's/range:.*/range: \"abc\"/' /etc/oeAware/plugin/realtime_tune.yaml;
oeawarectl -e realtime_tune" | grep "Instance enabled failed, because read realtime_tune.yaml failed"
    CHECK_RESULT $? 0 0 "Check range is exception value failed."
    P_SSH_CMD --node 2 --cmd "grep 'ERROR realtime_tune - cpu_isolation.range contains invalid characters: abc' /var/log/oeAware/server.log"
    CHECK_RESULT $? 0 0 "Check log ERROR failed."
    P_SSH_CMD --node 2 --cmd "echo > /var/log/oeAware/server.log;
\cp -f /etc/oeAware/plugin/realtime_tune.yaml_bak /etc/oeAware/plugin/realtime_tune.yaml;
sed -i 's/isolcpus:.*/isolcpus: oncall/' /etc/oeAware/plugin/realtime_tune.yaml;
oeawarectl -e realtime_tune" | grep "Instance enabled failed, because read realtime_tune.yaml failed"
    CHECK_RESULT $? 0 0 "Check isolcpus is exception value failed."
    P_SSH_CMD --node 2 --cmd "grep 'ERROR realtime_tune - Invalid cpu_isolation.features.isolcpus value: oncall' /var/log/oeAware/server.log"
    CHECK_RESULT $? 0 0 "Check log ERROR failed."
    P_SSH_CMD --node 2 --cmd "echo > /var/log/oeAware/server.log;
\cp -f /etc/oeAware/plugin/realtime_tune.yaml_bak /etc/oeAware/plugin/realtime_tune.yaml;
sed -i 's/nohz_full:.*/nohz_full: no/' /etc/oeAware/plugin/realtime_tune.yaml;
oeawarectl -e realtime_tune" | grep "Instance enabled failed, because read realtime_tune.yaml failed"
    CHECK_RESULT $? 0 0 "Check nohz_full is exception value failed."
    P_SSH_CMD --node 2 --cmd "grep 'ERROR realtime_tune - Invalid cpu_isolation.features.nohz_full value: no' /var/log/oeAware/server.log"
    CHECK_RESULT $? 0 0 "Check log ERROR failed."
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
