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
#@Desc      	:   Test ub vm life cycle
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

    # create vm
    create_vm_waiting_running "$vm_name" "$bus_instance" "$ub_dev_id"
    CHECK_RESULT $? 0 0 "create vm failed"
    chmod +x "${OET_PATH}/testcases/smoke-test/smoke-migrate/common/set_network.exp"
    expect "${OET_PATH}/testcases/smoke-test/smoke-migrate/common/set_network.exp" "$vm_name"
    wait_exec "ping -c 3 ${vm_ip:?}"
    CHECK_RESULT $? 0 0 "ping vm failed"
    vm_modprobe_ko "$vm_ip"
    vm_sshx "ls /sys/bus/ub/devices | wc -l | grep -wq 2"
    CHECK_RESULT $? 0 0 "check vm ub failed"

    # suspend vm
    virsh suspend "$vm_name" && sleep 5
    CHECK_RESULT $? 0 0 "suspend vm failed"

    # resume vm
    virsh resume "$vm_name" && sleep 5
    CHECK_RESULT $? 0 0 "resume vm failed"
    wait_exec "ping -c 3 ${vm_ip:?}" 30
    CHECK_RESULT $? 0 0 "ping vm failed"
    vm_sshx "ls /sys/bus/ub/devices | wc -l | grep -wq 2"
    CHECK_RESULT $? 0 0 "check vm ub failed"

    # reboot vm
    virsh reboot "$vm_name" && sleep 5
    CHECK_RESULT $? 0 0 "reboot vm failed"
    wait_exec "ping -c 3 ${vm_ip:?}"
    CHECK_RESULT $? 0 0 "ping vm failed"
    vm_modprobe_ko "$vm_ip"
    vm_sshx "ls /sys/bus/ub/devices | wc -l | grep -wq 2"
    CHECK_RESULT $? 0 0 "check vm ub failed"

    # internal reboot
    vm_sshx "reboot" && sleep 5
    CHECK_RESULT $? 0 0 "internal reboot failed"
    wait_exec "ping -c 3 ${vm_ip:?}"
    CHECK_RESULT $? 0 0 "ping vm failed"
    vm_modprobe_ko "$vm_ip"
    vm_sshx "ls /sys/bus/ub/devices | wc -l | grep -wq 2"
    CHECK_RESULT $? 0 0 "check vm ub failed"

    # reset vm
    virsh reset "$vm_name" && sleep 5
    CHECK_RESULT $? 0 0 "reset vm failed"
    wait_exec "ping -c 3 ${vm_ip:?}"
    CHECK_RESULT $? 0 0 "ping vm failed"
    vm_modprobe_ko "$vm_ip"
    vm_sshx "ls /sys/bus/ub/devices | wc -l | grep -wq 2"
    CHECK_RESULT $? 0 0 "check vm ub failed"

    # shutdown vm
    virsh shutdown "$vm_name" && sleep 5
    CHECK_RESULT $? 0 0 "shutdown vm failed"
    virsh list | grep "$vm_name"
    CHECK_RESULT $? 0 1 "check vm shutdown failed"
    
    # start vm again
    virsh start "$vm_name" && sleep 5
    CHECK_RESULT $? 0 0 "start vm failed"
    wait_exec "ping -c 3 ${vm_ip:?}"
    CHECK_RESULT $? 0 0 "ping vm failed"
    vm_modprobe_ko "$vm_ip"
    vm_sshx "ls /sys/bus/ub/devices | wc -l | grep -wq 2"
    CHECK_RESULT $? 0 0 "check vm ub failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf save
    post_clean
    ub_dev_restore "$bus_instance" "$ub_dev_id"
    LOG_INFO "End to restore the test environment."
}

main "$@"
