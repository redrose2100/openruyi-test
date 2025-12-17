#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   fanlirong
#@Contact   	:   fanlirong1@h-partners.com
#@Date      	:   2025-12-04
#@License   	:   Mulan PSL v2
#@Desc      	:   Test vm tcp migrate
#####################################

source "${OET_PATH}"/testcases/smoke-test/smoke-migrate/common/common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    pre_init
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    vm_name="2u2g_small_page"

    create_vm_waiting_running "$vm_name"
    CHECK_RESULT $? 0 0 "create vm failed"

    mig_vm "$vm_name" 2 "tcp"
    check_vm_exist "$vm_name"
    CHECK_RESULT $? 0 1 "check vm failed, vm should not exist in local: $vm_name"

    mig_vm_back "$vm_name" 2 "tcp"
    check_vm_exist "$vm_name"
    CHECK_RESULT $? 0 0 "check vm failed, vm should exist in local: $vm_name"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    post_clean
    LOG_INFO "End to restore the test environment."
}

main "$@"
