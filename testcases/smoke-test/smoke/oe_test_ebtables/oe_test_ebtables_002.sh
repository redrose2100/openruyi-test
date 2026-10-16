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
# @Author    :   huzheyuan
# @Contact   :   huzheyuan@uniontech.com
# @Date      :   2023/08/16
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of ebtables
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ebtables"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ebtables -A INPUT -s 11:22:33:44:55:66 -j ACCEPT
    ebtables -L INPUT | grep 11:22:33:44:55:66
    CHECK_RESULT $? 0 0 "Failed to Join rule"
    ebtables -D INPUT 1
    ebtables -L INPUT | grep 11:22:33:44:55:66
    CHECK_RESULT $? 0 1 "Successfully deleted rule"
    ebtables -A INPUT -s 11:22:33:44:55:66:77 -j ACCEPT
    ebtables -F INPUT
    ebtables -L INPUT | grep 11:22:33:44:55:66:77
    CHECK_RESULT $? 0 1 "successfully empty form"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
