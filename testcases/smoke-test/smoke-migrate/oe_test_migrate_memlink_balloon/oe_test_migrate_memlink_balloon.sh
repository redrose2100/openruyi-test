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
#@Desc      	:   Test memlink vm balloon enable after migration
#####################################

source "${OET_PATH}"/testcases/smoke-test/smoke-migrate/common/common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    pre_init
    memlink_init
    set_huge_mem_1_2 2048 2048
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    vm_name="2u2g_memlink_balloon"

    create_vm_waiting_running "$vm_name"
    CHECK_RESULT $? 0 0 "create vm failed" || exit 1

    chmod +x "${OET_PATH}/testcases/smoke-test/smoke-migrate/common/set_network.exp"
    expect "${OET_PATH}/testcases/smoke-test/smoke-migrate/common/set_network.exp" "$vm_name"
    wait_exec "ping -c 3 ${vm_ip:?}" 100
    CHECK_RESULT $? 0 0 "ping vm failed" || exit 1

    mig_vm "$vm_name" 2 "urma"
    check_vm_exist "$vm_name"
    CHECK_RESULT $? 0 1 "check vm failed, vm should not exist in local: $vm_name" || exit 1

    mig_vm_back "$vm_name" 2 "urma"
    check_vm_exist "$vm_name"
    CHECK_RESULT $? 0 0 "check vm failed, vm should exist in local: $vm_name" || exit 1

    wait_exec "ping -c 3 ${vm_ip:?}" 10
    CHECK_RESULT $? 0 0 "ping vm failed" || exit 1

    check_memlink_recycle "2" "1.5" "130" "50" "pass"
    CHECK_RESULT $? 0 0 "check memlink recycle failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    post_clean
    LOG_INFO "End to restore the test environment."
}

main "$@"
