#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangdi
#@Contact   	:   15710801006@163.com
#@Date      	:   2023-10-25
#@License   	:   Mulan PSL v2
#@Desc      	:   Create net bridge in config file and reboot
#####################################
# shellcheck disable=SC2120

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL bridge-utils 2
    test_nic=$(TEST_NIC 2 | awk '{print $1}')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    P_SSH_CMD --node 2 --cmd "echo 'DEVICE=br0
TYPE=Bridge
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=none
DEFROUTE=yes
NAME=br2
ONBOOT=yes
IPADDR=0.0.0.0
PREFIX=24' >/etc/sysconfig/network-scripts/ifcfg-br0"
    CHECK_RESULT $? 0 0 "Create br0 config file failed."

    P_SSH_CMD --node 2 --cmd "echo 'TYPE=Ethernet
BOOTPROTO=none
DEVICE=${test_nic}
ONBOOT=yes
BRIDGE=br0' >/etc/sysconfig/network-scripts/ifcfg-${test_nic}"
    CHECK_RESULT $? 0 0 "Create test nic config file failed."
    P_SSH_CMD --node 2 --cmd "brctl addbr br0"
    CHECK_RESULT $? 0 0 "Add brctl failed."
    P_SSH_CMD --node 2 --cmd "brctl addif br0 ${test_nic}"
    CHECK_RESULT $? 0 0 "Add brctl with ${test_nic} failed."
    P_SSH_CMD --node 2 --cmd "brctl show | grep br0 | grep ${test_nic}"
    CHECK_RESULT $? 0 0 "Check brctl created failed."
    REMOTE_REBOOT 2 180
    REMOTE_REBOOT_WAIT 2 180
    P_SSH_CMD --node 2 --cmd "brctl show | grep br0"
    CHECK_RESULT $? 0 0 "Check brctl reboot failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    P_SSH_CMD --node 2 --cmd "rm -rf /etc/sysconfig/network-scripts/ifcfg-br0 /etc/sysconfig/network-scripts/ifcfg-${test_nic}"
    DNF_REMOVE 2
    REMOTE_REBOOT 2 180
    REMOTE_REBOOT_WAIT 2 180
    LOG_INFO "End to restore the test environment."
}

main "$@"
