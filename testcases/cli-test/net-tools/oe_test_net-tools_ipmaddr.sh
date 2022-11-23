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
# @Date      :   2022/11/22
# @License   :   Mulan PSL v2
# @Desc      :   Test ipmaddr command function
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL net-tools
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    ipmaddr show dev "${NODE1_NIC}"
    CHECK_RESULT $?
    ipmaddr add 33:44:00:00:00:01 dev "${NODE1_NIC}"
    CHECK_RESULT $?
    ipmaddr show dev "${NODE1_NIC}" | grep "33:44:00:00:00:01"
    CHECK_RESULT $? 0 0 "Add multiaddr fail"
    ipmaddr del 33:44:00:00:00:01 dev "${NODE1_NIC}"
    CHECK_RESULT $?
    ipmaddr show dev "${NODE1_NIC}" | grep "33:44:00:00:00:01"
    CHECK_RESULT $? 1 0 "Delete multiaddr fail"
    ipmaddr -V | grep "net-tools" | grep [0-9]
    CHECK_RESULT $?
    ipmaddr -h | grep "Usage: ipmaddr"
    CHECK_RESULT $?
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
