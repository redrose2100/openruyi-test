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
#@Date      	:   2025-12-06
#@License   	:   Mulan PSL v2
#@Desc      	:   Test ub vm ping
#####################################

source "${OET_PATH}"/testcases/smoke-test/smoke-ubnative/common/common.sh

vm_name="ub_one_ubd"
bus_instance="cc08-a000-0-0-000000-0000000000000003"
ub_dev_id="00003"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    ub_env_init
    set_hugepages 4096
    ub_dev_init "$bus_instance" "$ub_dev_id"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    create_vm_waiting_running "$vm_name" "$bus_instance" "$ub_dev_id"
    CHECK_RESULT $? 0 0 "create vm failed"

    SLEEP_WAIT 180
    chmod +x "${OET_PATH}/testcases/smoke-test/smoke-migrate/common/set_network.exp"
    expect "${OET_PATH}/testcases/smoke-test/smoke-migrate/common/set_network.exp" "$vm_name"
    wait_exec "ping -c 3 ${vm_ip:?}" 100
    CHECK_RESULT $? 0 0 "ping vm failed"

    vm_modprobe_ko "$vm_ip"

    # 当前海思驱动不支持虚拟机内部启动ub网卡，本用例仅验证单虚拟机内ub直通正常
    vm_sshx "cat /sys/bus/ub/devices/00001/guid | grep cc08-a000-0-2-000000-0000000000000001"
    CHECK_RESULT $? 0 0 "check vm ub bus failed"

    ub_dev_guid=$(cat /sys/bus/ub/devices/"$ub_dev_id"/guid)
    vm_ub_dev_guid="${ub_dev_guid%-*}-0000000000000002"
    vm_sshx "cat /sys/bus/ub/devices/00002/guid | grep $vm_ub_dev_guid"
    CHECK_RESULT $? 0 0 "check vm ub dev failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    post_clean
    ub_dev_restore "$bus_instance" "$ub_dev_id"
    LOG_INFO "End to restore the test environment."
}

main "$@"
