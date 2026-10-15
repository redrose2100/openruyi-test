#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   chengweibin
# @Contact   :   chengweibin@uniontech.com
# @Date      :   2023-12-28
# @License   :   Mulan PSL v2
# @Desc      :   system common command ip netns
# ############################################
# shellcheck disable=SC1090,SC2119

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL iproute
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    ip netns add netns1
    CHECK_RESULT $? 0 0 "netns1 add failed"
    ip netns exec netns1 ip link list
    CHECK_RESULT $? 0 0 "Description Failed to enter the virtual network"
    ip netns exec netns1 ip link set dev lo up
    CHECK_RESULT $? 0 0 "up netns1 failed"
    ip netns exec netns1 ping -c 3 127.0.0.1
    CHECK_RESULT $? 0 0 "ping 127.0.0.1 failed"
    ip netns list | grep netns1
    CHECK_RESULT $? 0 0 "netns1 not found"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    ip netns delete netns1
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
