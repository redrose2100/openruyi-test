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
#@Desc      	:   Check network status
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    grep "local_address" /proc/net/raw
    CHECK_RESULT $? 0 0 "Check net raw failed."
    grep -e Type -e Device -e Function /proc/net/ptype
    CHECK_RESULT $? 0 0 "Check net ptype failed."
    grep -iwE "ip|icmp|tcp|udp" /proc/net/snmp
    CHECK_RESULT $? 0 0 "Check statistic snmp failed."
    grep protocol /proc/net/protocols
    CHECK_RESULT $? 0 0 "Check statistic protocols failed."
    grep -q "${NODE1_NIC}" /proc/net/arp
    CHECK_RESULT $? 0 0 "Check support arp failed."
    LOG_INFO "End to run test."
}

main "$@"
