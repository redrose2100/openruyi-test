#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   @meitingli
#@Contact   	:   bubble_mt@outlook.com
#@Date      	:   2021-06-04
#@License   	:   Mulan PSL v2
#@Desc      	:   raw by reboot
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    ssh_cmd_node "if \[\[ -f /etc/udev/rules.d/60-raw.rules \]\];then mv /etc/udev/rules.d/60-raw.rules /etc/udev/rules.d/60-raw.rules.bak; fi; touch /etc/udev/rules.d/60-raw.rules;"
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    ssh_cmd_node "echo 'ACTION==\\\"add\\\", RUN+=\\\"/bin/raw /dev/raw/raw1 1 1\\\"' > /etc/udev/rules.d/60-raw.rules"
    CHECK_RESULT $? 0 0 "Write cmd to rules failed."
    REMOTE_REBOOT 2
    REMOTE_REBOOT_WAIT 2
    ssh_cmd_node "blockdev --report /dev/raw/raw1"
    CHECK_RESULT $? 0 0 "Check report for /dev/raw/raw1 failed."
    ssh_cmd_node "raw -qa | grep /dev/raw/raw1"
    CHECK_RESULT $? 0 0 "Check /dev/raw/raw1 failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ssh_cmd_node "raw /dev/raw/raw1 0 0"
    ssh_cmd_node "rm -f /etc/udev/rules.d/60-raw.rules; if \[\[ -f /etc/udev/rules.d/60-raw.rules.bak \]\];then mv /etc/udev/rules.d/60-raw.rules.bak /etc/udev/rules.d/60-raw.rules; fi;"
    REMOTE_REBOOT 2
    REMOTE_REBOOT_WAIT 2
    LOG_INFO "End to restore the test environment."
}

main "$@"
