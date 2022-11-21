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
#@Date      	:   2021-07-01
#@License   	:   Mulan PSL v2
#@Desc      	:   create md to auto mount when reboot
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL mdadm 2
    test_disk="/dev/"$(TEST_DISK 2)
    ssh_cmd_node "mkdir /mnt/test_md"
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    for fs in ${FS_TYPE[@]}; do
        ssh_cmd_node "cp /etc/fstab /etc/fstab.bak"
        ssh_cmd_node "fdisk $test_disk << diskEof
n
p
1

+100M
Y
n
p
2

+100M
Y
w
diskEof"
        ssh_cmd_node "mdadm --stop /dev/md0"
        ssh_cmd_node "echo y | mdadm -C -v /dev/md0 -l 1 -n 2 ${test_disk}1 ${test_disk}2"
        CHECK_RESULT $? 0 0 "Create md failed."
        ssh_cmd_node "mdadm -Ds | grep /dev/md0"
        CHECK_RESULT $? 0 0 "Check md failed."
        if [[ $fs == "xfs" ]]; then
            ssh_cmd_node "mkfs -t $fs -f /dev/md0"
        else
            ssh_cmd_node "echo y | mkfs -t $fs /dev/md0"
        fi
        CHECK_RESULT $? 0 0 "mkfs failed."
        ssh_cmd_node "mount /dev/md0 /mnt/test_md"
        CHECK_RESULT $? 0 0 "Mount md failed."
        ssh_cmd_node "echo '/dev/md0 /mnt/test_md $fs defaults 0 0' >> /etc/fstab"
        REMOTE_REBOOT 2 60
        REMOTE_REBOOT_WAIT 2 60
	SLEEP_WAIT 60
        ssh_cmd_node "df -iT | grep /dev/md0"
        CHECK_RESULT $? 0 0 "Auto mount md when reboot failed."
        ssh_cmd_node "mv -f /etc/fstab.bak /etc/fstab"
        ssh_cmd_node "umount /dev/md0"
        ssh_cmd_node "mdadm --stop /dev/md0"
        ssh_cmd_node "mdadm --misc --zero-superblock ${test_disk}1"
        ssh_cmd_node "mdadm --misc --zero-superblock ${test_disk}2"
        ssh_cmd_node "fdisk $test_disk << diskEof
d

d

w
diskEof"
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ssh_cmd_node "rm -rf /mnt/test_md"
    DNF_REMOVE
    REMOTE_REBOOT 2 60
    REMOTE_REBOOT_WAIT 2 60
    LOG_INFO "End to restore the test environment."
}

main "$@"

