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
#@Date      	:   2021-06-25
#@License   	:   Mulan PSL v2
#@Desc      	:   Auto mount swap device
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    test_disk="/dev/"$(TEST_DISK 2)
    ssh_cmd_node "cp /etc/fstab /etc/fstab.bak"
    ssh_cmd_node "fdisk $test_disk << diskEof
n
p
1

100000
w
diskEof"
    dmname=${test_disk}1
    ssh_cmd_node "mkswap $dmname"
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    ssh_cmd_node "echo '$dmname swap swap defaults 0 0' >> /etc/fstab"
    CHECK_RESULT $? 0 0 "Add mount swap on /etc/fstab failed."
    REMOTE_REBOOT 2 180
    REMOTE_REBOOT_WAIT 2 180
    SLEEP_WAIT 60
    ssh_cmd_node "free -m | grep -i 'swap' | awk '{print \$4}' | grep 4103"
    CHECK_RESULT $? 0 0 "Check swap size failed."
    ssh_cmd_node "swapon -v | grep '$dmname'"
    CHECK_RESULT $? 0 0 "Add swap failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm_cmd="fdisk $test_disk << diskEof
d

w
diskEof"
    ssh_cmd_node "$rm_cmd"
    ssh_cmd_node "mv -f /etc/fstab.bak /etc/fstab"
    REMOTE_REBOOT 2 180
    REMOTE_REBOOT_WAIT 2 180
    LOG_INFO "End to restore the test environment."
}

main "$@"
