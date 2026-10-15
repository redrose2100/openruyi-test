#!/usr/bin/bash

# Copyright (c) 2025 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2025-08-21
# @License   :   Mulan PSL v2
# @Desc      :   ebtables additional command testing
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ebtables"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    ebtables -t filter -L
    CHECK_RESULT $? 0 0 "Failed to list filter table"
    ebtables -t nat -L
    CHECK_RESULT $? 0 0 "Failed to list nat table"
    ebtables -t broute -L
    CHECK_RESULT $? 0 0 "Failed to list broute table"

    ebtables -A INPUT -s 11:22:33:44:55:66 -j ACCEPT
    ebtables -L INPUT | grep -q "11:22:33:44:55:66"
    CHECK_RESULT $? 0 0 "Failed to add ACCEPT rule"
    ebtables -A INPUT -s aa:bb:cc:dd:ee:ff -j DROP
    ebtables -L INPUT | grep -q "aa:bb:cc:dd:ee:ff"
    CHECK_RESULT $? 0 0 "Failed to add DROP rule"
    ebtables -F INPUT

    ebtables -A FORWARD -d 11:22:33:44:55:66 -j ACCEPT
    ebtables -L FORWARD | grep -q "11:22:33:44:55:66"
    CHECK_RESULT $? 0 0 "Failed to add destination MAC filter"
    ebtables -A FORWARD -d aa:bb:cc:dd:ee:ff -j DROP
    ebtables -L FORWARD | grep -q "aa:bb:cc:dd:ee:ff"
    CHECK_RESULT $? 0 0 "Failed to add destination MAC DROP rule"
    ebtables -F FORWARD

    ebtables -P INPUT ACCEPT
    CHECK_RESULT $? 0 0 "Failed to set chain policy"
    ebtables -A INPUT -s 11:22:33:44:55:66 -j ACCEPT
    ebtables -L INPUT | grep -q "11:22:33:44:55:66"
    CHECK_RESULT $? 0 0 "Failed to verify rule after policy set"

    ebtables -F INPUT
    ebtables -L INPUT | grep -q "11:22:33:44:55:66"
    CHECK_RESULT $? 1 0 "Rule still exists after flushing chain"

    ebtables -A INPUT -s 11:22:33:44:55:66 -j ACCEPT
    ebtables -A FORWARD -s aa:bb:cc:dd:ee:ff -j ACCEPT
    ebtables -F
    ebtables -L INPUT | grep -q "11:22:33:44:55:66"
    CHECK_RESULT $? 1 0 "INPUT rule exists after global flush"
    ebtables -L FORWARD | grep -q "aa:bb:cc:dd:ee:ff"
    CHECK_RESULT $? 1 0 "FORWARD rule exists after global flush"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"