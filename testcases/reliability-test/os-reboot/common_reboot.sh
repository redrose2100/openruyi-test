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
# @Desc      :   Reboot common file
# #############################################
# shellcheck disable=SC2001
source "$OET_PATH/libs/locallibs/common_lib.sh"

function build_env() {
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    if [ -z "$NODE2_BMC_IP" ]; then
        echo "BMC_IP not configurable in this environment, Skipping test."
        exit 255
    fi
    DNF_INSTALL "ipmitool OpenIPMI net-tools"
    test_ip=$(echo "$NODE2_BMC_IP" | sed 's/\.[^.]*$//')
    ifconfig "${NODE1_NIC}":1 "${test_ip}".200/24 broadcast 255.255.255.0 up
    modprobe ipmi_watchdog
    modprobe ipmi_poweroff
    modprobe ipmi_devintf
    modprobe ipmi_msghandler
    modprobe ipmi_si
    systemctl restart ipmievd.service
}

function clean_env() {
    export LANG=${OLD_LANG}
    ifconfig "${NODE1_NIC}":1 "${test_ip}".200/24 broadcast 255.255.255.0 down
    DNF_REMOVE "$@"
    modprobe -r ipmi_watchdog
    modprobe -r ipmi_poweroff
    modprobe -r ipmi_devintf
    modprobe -r ipmi_ssif
    modprobe -r ipmi_si
    modprobe -r ipmi_msghandler
}

# Bounded poll until the given node disappears from the network (shutdown/reboot in progress).
# Usage: WAIT_NODE_DOWN <node> [timeout_sec]
# Returns 0 when the node became unreachable before the timeout, 1 when it is still reachable.
#
# Why this helper exists: for the graceful shutdown path (systemctl reboot / halt /
# shutdown / init 6) the time between issuing the command and the NIC actually going
# down routinely exceeds 10 seconds on a virtual machine. The previous pattern was
# "SLEEP_WAIT <fixed> + a single ping", so a machine that had not finished going down
# yet was reported as "the shutdown command took no effect", producing a large number
# of false failures in the os-reboot suite (task 276346). A bounded poll only asks the
# question that matters: was the node ever observed going down?
function WAIT_NODE_DOWN() {
    local node=${1-2}
    local timeout=${2-120}
    local ip_var="NODE${node}_IPV4"
    local ip=${!ip_var}
    local waited=0

    if [ -z "$ip" ]; then
        LOG_ERROR "WAIT_NODE_DOWN: NODE${node}_IPV4 is empty, cannot detect node down."
        return 1
    fi

    while [ "$waited" -lt "$timeout" ]; do
        if ! ping -c 1 -w 1 "$ip" >/dev/null 2>&1; then
            LOG_INFO "Node ${node} (${ip}) became unreachable after ${waited}s, reboot is in progress."
            return 0
        fi
        sleep 1
        waited=$((waited + 1))
    done

    LOG_ERROR "Node ${node} (${ip}) is still reachable after ${timeout}s, shutdown command took no effect."
    return 1
}
main "$@"
