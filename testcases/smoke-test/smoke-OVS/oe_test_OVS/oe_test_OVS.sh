#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zengcongwei
# @Contact   :   735811396@qq.com
# @Date      :   2020/5/21
# @License   :   Mulan PSL v2
# @Desc      :   Test OVS
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    ip netns list|awk '{print $1}'|xargs ip netns delete
    if echo "${NODE1_OS_VERSION}" | grep -E "debian|velinux";then
        DNF_INSTALL openvswitch-switch
        systemctl start openvswitch-switch
    else
        DNF_INSTALL openvswitch
        if getenforce | grep -i Enforcing; then
            setenforce 0
            result_flag=1
        fi
        systemctl start openvswitch
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ip netns add ns_1
    CHECK_RESULT $?
    ip netns list | grep ns_1
    CHECK_RESULT $?
    ip netns add ns_2
    CHECK_RESULT $?
    ip netns list | grep ns_2
    CHECK_RESULT $?
    if ! df -h / |grep overlay; then
        ovs-vsctl add-br br0
        CHECK_RESULT $?
        ip a | grep -w br0
        CHECK_RESULT $?
        ovs-vsctl add-port br0 tap1 -- set Interface tap1 type=internal
        CHECK_RESULT $?
        ip a | grep tap1
        CHECK_RESULT $?
        ip link set tap1 netns ns_1
        CHECK_RESULT $?
        ip a | grep tap1
        CHECK_RESULT $? 1
        ip netns exec ns_1 ip link set dev tap1 up
        CHECK_RESULT $?
        ip netns list | grep ns_1 | grep "id: 0"
        CHECK_RESULT $?
        ovs-vsctl add-port br0 tap2 -- set Interface tap2 type=internal
        CHECK_RESULT $?
        ip a | grep tap2
        CHECK_RESULT $?
        ip link set tap2 netns ns_2
        CHECK_RESULT $?
    fi
    ip a | grep tap2
    CHECK_RESULT $? 1
    if ! df -h / |grep overlay; then
         ip netns exec ns_2 ip link set dev tap2 up
         CHECK_RESULT $?
         ip netns list | grep ns_2 | grep "id: 1"
         CHECK_RESULT $?
         ip netns exec ns_1 ip addr add 10.1.1.1/24 dev tap1
         CHECK_RESULT $?
    fi
    ip --all netns exec echo hello | grep -A 1 "netns: ns_1" | grep hello
    CHECK_RESULT $?
    if ! df -h / |grep overlay; then
        ip netns exec ns_2 ip addr add 10.1.1.2/24 dev tap2
        CHECK_RESULT $?
    fi
    ip --all netns exec echo hello | grep -A 1 "netns: ns_2" | grep hello
    CHECK_RESULT $?
    ip netns exec ns_1 ip link set lo up
    CHECK_RESULT $?
    ip netns exec ns_2 ip link set lo up
    CHECK_RESULT $?
    if ! df -h / |grep overlay; then
        ip netns exec ns_2 ping -c 3 10.1.1.1
        CHECK_RESULT $?
        ovs-vsctl del-br br0
        CHECK_RESULT $?
    fi
    ip a | grep -w br0
    CHECK_RESULT $? 1
    ip netns delete ns_1
    CHECK_RESULT $?
    ip netns list | grep ns_1
    CHECK_RESULT $? 1
    ip netns delete ns_2
    CHECK_RESULT $?
    ip netns list | grep ns_2
    CHECK_RESULT $? 1
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment." 
    if echo "${NODE1_OS_VERSION}" | grep -E "debian|velinux";then
        systemctl stop openvswitch-switch
    else
        if $result_flag -eq 1; then
            setenforce 1
        fi
        systemctl stop openvswitch
    fi
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}
main "$@"
