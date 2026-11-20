#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2022/07/08
# @License   :   Mulan PSL v2
# @Desc      :   Test ifconfig add ipv6
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL inetutils
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # 用例名是 ip_ipv6，但原脚本全程用 ifconfig。新版 net-tools 已不支持
    # `ifconfig <nic> inet6 add ...`（报 "inet6 is not a supported address family"），
    # 且每个接口只允许一个 add 地址。这里改用 ip addr，语义与用例名一致。
    ip addr add 4::4/64 dev ${NODE1_NIC}
    CHECK_RESULT $? 0 0 "Failed to add ipv6 4::4"
    ip addr show dev ${NODE1_NIC} | grep "4::4"
    CHECK_RESULT $? 0 0 "Failed to show ipv6 4::4"
    ip addr add 1111:1111:1111:1111:1111:1111:1111:1111/64 dev ${NODE1_NIC}
    CHECK_RESULT $? 0 0 "Failed to add ipv6 1111:"
    ip addr show dev ${NODE1_NIC} | grep "1111:1111:1111:1111:1111:1111:1111:1111"
    CHECK_RESULT $? 0 0 "Failed to show ipv6 1111:"
    ip addr add 2001:da8:8000:d010:0:5efe:3.3.3.3/64 dev ${NODE1_NIC}
    CHECK_RESULT $? 0 0 "Failed to add ipv6 2001:"
    ip addr show dev ${NODE1_NIC} | grep "2001:da8:8000:d010:0:5efe:3.3.3.3"
    CHECK_RESULT $? 0 0 "Failed to show ipv6 2001:"
    ip addr add 7::7/64 dev ${NODE1_NIC}
    CHECK_RESULT $? 0 0 "Failed to add ipv6 7::7"
    ip addr show dev ${NODE1_NIC} | grep "7::7"
    CHECK_RESULT $? 0 0 "Failed to show ipv6 7::7"
    ip addr add 9000:0000:0000:0000:0000:0000:0000:0009/64 dev ${NODE1_NIC}
    CHECK_RESULT $? 0 0 "Failed to add ipv6 9000:"
    ip addr show dev ${NODE1_NIC} | grep "9000::9"
    CHECK_RESULT $? 0 0 "Failed to show ipv6 9000:"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ip addr del 4::4/64 dev ${NODE1_NIC} 2>/dev/null
    ip addr del 1111:1111:1111:1111:1111:1111:1111:1111/64 dev ${NODE1_NIC} 2>/dev/null
    ip addr del 2001:da8:8000:d010:0:5efe:3.3.3.3/64 dev ${NODE1_NIC} 2>/dev/null
    ip addr del 7::7/64 dev ${NODE1_NIC} 2>/dev/null
    ip addr del 9000:0000:0000:0000:0000:0000:0000:0009/64 dev ${NODE1_NIC} 2>/dev/null
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
