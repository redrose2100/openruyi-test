#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   kouhuiying
# @Contact   :   kouhuiying@uniontech.com
# @Date      :   2022/11/17
# @License   :   Mulan PSL v2
# @Desc      :   Test route command function
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL net-tools
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    route | grep default | grep "${NODE1_NIC}" | grep "_gateway"
    CHECK_RESULT $?
    local ip_gateway=$(ip route | grep "default via" |grep -Eo "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
    route -n | grep "${ip_gateway}"
    CHECK_RESULT $?
    route -n | grep "_gateway"
    CHECK_RESULT $? 1
    route add -net 192.168.0.0 netmask 255.255.255.0 dev "${NODE1_NIC}"
    CHECK_RESULT $? 0 0 "Add route fail"
    route del -net 192.168.0.0 netmask 255.255.255.0
    CHECK_RESULT $? 0 0 "Delete route fail"
    route add default gw "${ip_gateway}" dev "${NODE1_NIC}" metric 1000
    CHECK_RESULT $? 0 0 "Add default route fail"
    route del default gw "${ip_gateway}" dev "${NODE1_NIC}" metric 1000
    CHECK_RESULT $? 0 0 "Delete default route fail"
    route -h | grep "Usage: route"
    CHECK_RESULT $?
    route -V | grep "net-tools" | grep [0-9]
    CHECK_RESULT $?
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
