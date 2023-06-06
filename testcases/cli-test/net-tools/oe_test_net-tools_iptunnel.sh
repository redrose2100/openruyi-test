#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiechangyan1
# @Contact   :   xiechangyan@uniontech.com
# @Date      :   2023-05-22
# @License   :   Mulan PSL v2
# @Desc      :   Use iptunnel case
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "net-tools"
    my_network=$(ifconfig -s | awk '{if ($1 != "Iface" && $1 != "lo") print $1}' |awk 'NR==1')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    iptunnel add ipiptun mode gre remote 10.7.10.21 local 10.7.10.22 ttl 64 dev "$my_network"
    CHECK_RESULT $? 0 0 "Error,check network name"
    ip a | grep '10.7.10.21'
    CHECK_RESULT $? 0 0 "Error,fail to add iptunnel"
    iptunnel del ipiptun mode gre remote 10.7.10.21 local 10.7.10.22 ttl 64 dev "$my_network"
    CHECK_RESULT $? 0 0 "Error,Fail to delete,Pleasse check the network name"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
