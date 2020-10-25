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
#@Author        :   zhujinlong
#@Contact       :   zhujinlong@163.com
#@Date          :   2023-08-17
#@License       :   Mulan PSL v2
#@Desc          :   Manage StratoVirt virtual machines
#####################################
# shellcheck disable=SC1091,SC2154

source common/common_stratovirt.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    pre_env
    create_stratovirt_vm &
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    expect <<-EOF
        spawn ncat -U /tmp/stratovirt.socket
        expect "*QMP*"
        send "{ \"execute\": \"query-status\" }\\n"
        expect "*\"status\":\"running\"*"
        send "{ \"execute\": \"query-cpus\" }\\n"
        expect "*\"CPU\":0*"
        send "{ \"execute\": \"query-hotpluggable-cpus\" }\\n"
        expect "*vcpus-count*"
        send "{\"execute\":\"stop\"}\\n"
        expect "*STOP*"
        send "{\"execute\":\"cont\"}\\n"
        expect "*RESUME*"
        send "{\"execute\":\"quit\"}\\n"
        expect "*SHUTDOWN*"
    expect eof   
EOF
    CHECK_RESULT $? 0 0 'Failed to quit the stratovirt VM'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f vmlinux.bin "$openeulerversion"-stratovirt-"${NODE1_FRAME}".img /tmp/stratovirt.socket /tmp/tmp*
    LOG_INFO "End to restore the test environment."
}

main "$@"
