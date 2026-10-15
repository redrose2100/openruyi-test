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
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2024-1-11
# @License   :   Mulan PSL v2
# @Desc      :   arptables function
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL arptables
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    arptables -h
    CHECK_RESULT $? 0 0 "show arptables help fail"
    arptables -L
    CHECK_RESULT $? 0 0 "List the rules in a chain or all chains fail"
    arptables -F
    CHECK_RESULT $? 0 0 "Delete all rules in  chain or all chains fail"
    arptables -A INPUT --source-ip 192.168.1.100 -j DROP
    CHECK_RESULT $? 0 0 "Failed to add arptables rule"
    arptables -L | grep -q "192.168.1.100"
    CHECK_RESULT $? 0 0 "Added rule not found in listing"
    arptables -D INPUT --source-ip 192.168.1.100 -j DROP
    CHECK_RESULT $? 0 0 "Failed to delete arptables rule"
    arptables -L | grep -q "192.168.1.100"
    CHECK_RESULT $? 1 0 "Deleted rule still exists in listing"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
