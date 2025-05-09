#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhujinlong
#@Contact       :   zhujinlong@163.com
#@Date          :   2023-07-24
#@License       :   Mulan PSL v2
#@Desc          :   Common Skill: Configure the network and ssh
#####################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    Default_LANG=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Configure network
    Network_card_name=$(ip a | grep "state UP" | awk -F":" '{print $2; exit}' | tr -d ' ')
    ip address add 192.168.0.10/24 dev "${Network_card_name}"
    CHECK_RESULT $? 0 0 "Failed to config ip address"
    ip address show dev "${Network_card_name}" | grep "192.168.0.10/24"
    CHECK_RESULT $? 0 0 "Failed to add Nic 192.168.0.10"
    ip addr del 192.168.0.10/24 dev "${Network_card_name}"
    CHECK_RESULT $? 0 0 "Failed to delete ip address"
    ip addr show dev "${Network_card_name}" | grep "192.168.0.10/24"
    CHECK_RESULT $? 1 0 "Failed to delete Nic 192.168.0.10"
    ip route add 192.168.2.1 dev "${Network_card_name}"
    CHECK_RESULT $? 0 0 "Failed to config static routes"
    ip route list | grep "192.168.2.1"
    CHECK_RESULT $? 0 0 "Failed to add a static route to the host address"
    ip route del 192.168.2.1 dev "${Network_card_name}"
    CHECK_RESULT $? 0 0 "Failed to delete static routes"
    ip route list | grep "192.168.2.1"
    CHECK_RESULT $? 1 0 "Failed to del a static route to the host address"
    ip route add 192.168.2.0/24 dev "${Network_card_name}"
    CHECK_RESULT $? 0 0 "Failed to config static routes"
    ip route list | grep "192.168.2.0/24"
    CHECK_RESULT $? 0 0 "Failed to add a static route to the network"
    ip route del 192.168.2.0/24 dev "${Network_card_name}"
    CHECK_RESULT $? 0 0 "Failed to delete static routes"
    ip route list | grep "192.168.2.0/24"
    CHECK_RESULT $? 1 0 "Failed to delete a static route to the network"
    if [ -f /etc/sysconfig/network-scripts/ifcfg-"${Network_card_name}" ];then
        grep "TYPE=Ethernet" /etc/sysconfig/network-scripts/ifcfg-"${Network_card_name}"
        CHECK_RESULT $? 0 0 "Failed to get network info for the ifcfg file"
    fi
    # Configure SSH
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
    sed -i "s/#ClientAliveInterval 0/ClientAliveInterval 120/" /etc/ssh/sshd_config
    systemctl restart sshd
    CHECK_RESULT $? 0 0 "Failed to restart sshd service"
    SLEEP_WAIT 3
    systemctl status sshd | grep "active (running)"
    CHECK_RESULT $? 0 0 "sshd service is not running"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=$Default_LANG
    mv -f /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
    LOG_INFO "End to restore the test environment."
}

main "$@"
