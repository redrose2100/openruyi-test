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
#@Date      	:   2021-08-27
#@License   	:   Mulan PSL v2
#@Desc      	:   Use scapy to
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."

    DNF_INSTALL python3-scapy

    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."

    scapy <<EOF
a=sendp(Ether()/IP(dst="${NODE2_IPV4}",ttl=(1,4)),iface="${NODE1_NIC}")
EOF

    CHECK_RESULT $? 0 0 "Send package to ${NODE2_IPV4} with return_packets failed."
    scapy <<EOF
b=sendp(Ether()/IP(dst="${NODE2_IPV4}",ttl=(1,4)),iface="${NODE1_NIC}",return_packets=True)
b.show()
EOF
    CHECK_RESULT $? 0 0 "Send package to ${NODE2_IPV4} failed."
    scapy <<EOF
c=sr1(IP(dst="${NODE2_IPV4}")/ICMP()/"xxxxxxxx")
c.show()
EOF
    CHECK_RESULT $? 0 0 "Send package to ${NODE2_IPV4} by ICMP failed."
    scapy <<EOF
sr(IP(dst="${NODE2_IPV4}")/TCP(sport=RandShort(),dport=[440,441,442,443],flags="S"))
EOF
    CHECK_RESULT $? 0 0 "Send package to ${NODE2_IPV4} by TCP failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environme."

    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"
