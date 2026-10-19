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
#@Desc      	:   Create net bridge
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL bridge-utils
    test_nic=$(TEST_NIC 1 | awk '{print $1}')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    brctl addbr br0
    CHECK_RESULT $? 0 0 "Add brctl failed."
    brctl addif br0 "${test_nic}"
    CHECK_RESULT $? 0 0 "Add brctl with ${test_nic} failed."
    brctl show | grep br0 | grep -q "${test_nic}"
    CHECK_RESULT $? 0 0 "Check brctl created failed."
    brctl delif br0 "${test_nic}"
    CHECK_RESULT $? 0 0 "Delete ${test_nic} from brctl failed."
    brctl delbr br0
    CHECK_RESULT $? 0 0 "Delete brctl failed."
    brctl show | grep br0
    CHECK_RESULT $? 1 0 "Check brctl deleted failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
