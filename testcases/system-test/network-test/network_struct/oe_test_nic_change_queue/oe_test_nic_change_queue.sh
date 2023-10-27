#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
#@Desc      	:   Change nic queue
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL net-tools
    test_nic=$(TEST_NIC 1)
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    ori_rx=$(ethtool -g "${test_nic}" | grep "RX:" | tail -n 1 | awk '{print $2}')
    CHECK_RESULT $? 0 0 "Check rx failed."
    ori_tx=$(ethtool -g "${test_nic}" | grep "TX:" | tail -n 1 | awk '{print $2}')
    CHECK_RESULT $? 0 0 "Check tx failed."
    ethtool -G "${test_nic}" rx 4096
    CHECK_RESULT $? 0 0 "Change rx failed."
    ethtool -G "${test_nic}" tx 4096
    CHECK_RESULT $? 0 0 "Change tx failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ethtool -G "${test_nic}" rx "$ori_rx"
    ethtool -G "${test_nic}" tx "$ori_tx"
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
