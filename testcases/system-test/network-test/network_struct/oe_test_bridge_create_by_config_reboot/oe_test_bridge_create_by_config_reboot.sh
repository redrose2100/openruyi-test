#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   meitingli
#@Contact   	:   244349477@qq.com
#@Date      	:   2021-08-12
#@License   	:   Mulan PSL v2
#@Desc      	:   Create net bridge in config file and reboot
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."

    DNF_INSTALL bridge-utils 2
    test_nic=$(TEST_NIC 2)

    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."

    SSH_CMD "echo 'DEVICE=br0
TYPE=Bridge
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=none
DEFROUTE=yes
NAME=br2
ONBOOT=yes
IPADDR=0.0.0.0
PREFIX=24' >/etc/sysconfig/network-scripts/ifcfg-br0" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    CHECK_RESULT $? 0 0 "Create br0 config file failed."

    SSH_CMD "echo 'TYPE=Ethernet
BOOTPROTO=none
DEVICE=${test_nic}
ONBOOT=yes
BRIDGE=br0' >/etc/sysconfig/network-scripts/ifcfg-${test_nic}" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    CHECK_RESULT $? 0 0 "Create test nic config file failed."

    SSH_CMD "brctl addbr br0" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    CHECK_RESULT $? 0 0 "Add brctl failed."
    SSH_CMD "brctl addif br0 ${test_nic}" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    CHECK_RESULT $? 0 0 "Add brctl with ${test_nic} failed."
    SSH_CMD "brctl show | grep br0 | grep ${test_nic}" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    CHECK_RESULT $? 0 0 "Check brctl created failed."

    REMOTE_REBOOT
    REMOTE_REBOOT_WAIT

    SSH_CMD "brctl show | grep br0" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    CHECK_RESULT $? 0 0 "Check brctl reboot failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    SSH_CMD "rm -f /etc/sysconfig/network-scripts/ifcfg-br0 /etc/sysconfig/network-scripts/ifcfg-${test_nic}" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    DNF_REMOVE
    REMOTE_REBOOT
    REMOTE_REBOOT_WAIT

    LOG_INFO "End to restore the test environment."
}

main "$@"
