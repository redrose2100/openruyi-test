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
#@Date      	:   2021-06-24
#@License   	:   Mulan PSL v2
#@Desc      	:   Close swap and reboot
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    ssh_cmd_node "cp /etc/fstab /etc/fstab.bak"
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    ssh_cmd_node "sed -i '\\\/dev\\\/mapper\\\/openeuler-swap/d' /etc/fstab"
    CHECK_RESULT $? 0 0 "Delete mount swap on /etc/fstab failed."
    REMOTE_REBOOT 2
    REMOTE_REBOOT_WAIT 2
    ssh_cmd_node "free -m | grep -i 'swap' | awk '{print $4}' | grep 0"
    CHECK_RESULT $? 0 0 "Close swap failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ssh_cmd_node "mv -f /etc/fstab.bak /etc/fstab"
    REMOTE_REBOOT 2
    REMOTE_REBOOT_WAIT 2
    LOG_INFO "End to restore the test environment."
}

main "$@"

