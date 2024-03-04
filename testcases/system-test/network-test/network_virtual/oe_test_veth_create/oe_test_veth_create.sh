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
#@Desc      	:   Create namespace and veth
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    ip netns add testns
    CHECK_RESULT $? 0 0 "Add namespace failed."
    ip netns list | grep -q "testns"
    CHECK_RESULT $? 0 0 "Check namespace failed."
    ip link add testveth01 type veth peer name testveth02
    CHECK_RESULT $? 0 0 "Add testveth01,testveth02 failed."
    ip link list | grep -q "testveth02@testveth01"
    CHECK_RESULT $? 0 0 "Check testveth01 failed."
    ip link list | grep -q "testveth01@testveth02"
    CHECK_RESULT $? 0 0 "Check testveth02 failed."
    ip link del testveth01
    CHECK_RESULT $? 0 0 "Delete veth failed."
    ip link list | grep -q "^testveth"
    CHECK_RESULT $? 1 0 "Check testveth01,testveth02 are deleted failed."
    ip netns del testns
    CHECK_RESULT $? 0 0 "Delete testns failed."
    ip netns list | grep -q "testns"
    CHECK_RESULT $? 1 0 "Check namespace is deleted failed."
    LOG_INFO "End to run test."
}

main "$@"
