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
#@Desc      	:   Create namespace and veth
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL net-tools
    head_ip=$(echo "${NODE1_IPV4}" | cut -d '.' -f 1)
    ((head_ip++))
    ip=$(echo "${NODE1_IPV4}" | cut -d '.' -f 2-4)
    new_ip="$head_ip.$ip"
    ip netns add testns
    ip link add testveth01 type veth peer name testveth02
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    ip link set testveth01 netns testns
    CHECK_RESULT $? 0 0 "Add veth into namespace failed."
    ip netns exec testns ifconfig testveth01 "${new_ip}"/16 up
    CHECK_RESULT $? 0 0 "Add ip failed."
    ping -c 4 "${new_ip}" -I testveth02
    CHECK_RESULT $? 2 0 "The netns veth can be ping unexpectly."
    ip netns exec testns ip link list | grep -q "testveth01"
    CHECK_RESULT $? 0 0 "Check testveth01 in testns failed."
    ip netns exec testns sh <<EOF
    pwd
    exit
EOF
    CHECK_RESULT $? 0 0 "Open namespace bash failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ip netns exec testns ip link del testveth01
    ip netns del testns
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
