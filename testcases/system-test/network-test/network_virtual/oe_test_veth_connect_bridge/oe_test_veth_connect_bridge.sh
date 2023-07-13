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
#@Date      	:   2021-08-17
#@License   	:   Mulan PSL v2
#@Desc      	:   Connect two netns by bridge
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."

    DNF_INSTALL "bridge-utils net-tools"
    new_ip=$(echo ${NODE1_IPV4} | cut -d '.' -f 1-3).120
    ip1=$(echo ${NODE1_IPV4} | cut -d '.' -f 1-3).123
    ip2=$(echo ${NODE1_IPV4} | cut -d '.' -f 1-3).125
    brctl addbr testbr
    brctl stp testbr off
    ip link set dev testbr up
    ifconfig testbr ${new_ip}/24 up
    ip netns add testns01
    ip netns add testns02

    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Addd first veth
    ip link add testveth01 type veth peer name br-testveth01 
    CHECK_RESULT $? 0 0 "Create testveth01 failed."
    brctl addif testbr br-testveth01
    CHECK_RESULT $? 0 0 "Add br-testveth01 into bridge failed."
    ip link set testveth01 netns testns01
    ip netns exec testns01 ip link set dev testveth01 up
    ip link set dev br-testveth01 up
    ip netns exec testns01 ifconfig testveth01 ${ip1}/24 up
    ip netns exec testns01 ip route add default via ${new_ip}
    CHECK_RESULT $? 0 0 "Add ip1 or route failed."
    ping ${ip1} -c 4 
    CHECK_RESULT $? 0 0 "Ping ip1 failed."

    # Addd second veth
    ip link add testveth02 type veth peer name br-testveth02
    CHECK_RESULT $? 0 0 "Create testveth02 failed."
    brctl addif testbr br-testveth02
    CHECK_RESULT $? 0 0 "Add br-testveth02 into bridge failed."
    ip link set testveth02 netns testns02
    ip netns exec testns02 ip link set dev testveth02 up
    ip link set dev br-testveth02 up
    ip netns exec testns02 ifconfig testveth02 ${ip2}/24 up
    ip netns exec testns02 ip route add default via ${new_ip}
    CHECK_RESULT $? 0 0 "Add ip2 or route failed."
    ping ${ip2} -c 4 
    CHECK_RESULT $? 0 0 "Ping ip2 failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    ip netns exec testns01 ip link del testveth01
    ip netns del testns01
    ip netns del testns02
    ip link del br-testveth01
    ip link del br-testveth02
    ifconfig testbr down
    brctl delbr testbr
    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"
