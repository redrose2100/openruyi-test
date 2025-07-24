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
# shellcheck disable=SC1091,SC2068

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL mdadm 2
    test_disk=$(fdisk -l | grep "Disk /dev/" | grep -vE 'loop|mapper' | awk -F ' |:|：' '{print $2}' | awk 'NR==2')
    P_SSH_CMD --node 2 --cmd "mkdir /mnt/test_md"
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    if [ "${NODE1_FRAME}" == "riscv64" ]; then
        FS_TYPE="ext3 ext4"
    fi
    for fs in ${FS_TYPE[@]}; do
        P_SSH_CMD --node 2 --cmd "cp /etc/fstab /etc/fstab.bak;
        fdisk $test_disk << diskEof
n
p
1

+350M
n
p
2

+350M
w
diskEof
        echo y | mdadm -C -v /dev/md0 -l 1 -n 2 ${test_disk}1 ${test_disk}2"
        CHECK_RESULT $? 0 0 "Create md failed."
        P_SSH_CMD --node 2 --cmd "mdadm -Ds | grep /dev/md0"
        CHECK_RESULT $? 0 0 "Check md failed."
        if [[ $fs == "xfs" ]]; then
            P_SSH_CMD --node 2 --cmd "mkfs -t $fs -f /dev/md0"
        else
            P_SSH_CMD --node 2 --cmd "echo y | mkfs -t $fs /dev/md0"
        fi
        CHECK_RESULT $? 0 0 "mkfs failed."
        P_SSH_CMD --node 2 --cmd "mount /dev/md0 /mnt/test_md"
        CHECK_RESULT $? 0 0 "Mount md failed."
        md0_uuid=$(P_SSH_CMD --node 2 --cmd "blkid /dev/md0 | awk -F ' ' '{print \$2}'")
        P_SSH_CMD --node 2 --cmd "echo '$md0_uuid /mnt/test_md $fs defaults 0 0' >> /etc/fstab"
        REMOTE_REBOOT 2 60
        P_SSH_CMD --node 2 --cmd "df -iT | grep -E '/dev/md0|/dev/md127'"
        CHECK_RESULT $? 0 0 "Auto mount md when reboot failed."
        P_SSH_CMD --node 2 --cmd "mv -f /etc/fstab.bak /etc/fstab;
        umount /dev/md0 || umount /dev/md127;
        mdadm --stop /dev/md0 || mdadm --stop /dev/md127;
        mdadm --misc --zero-superblock ${test_disk}1;
        mdadm --misc --zero-superblock ${test_disk}2;
        fdisk $test_disk << diskEof
d

d

w
diskEof"
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    P_SSH_CMD --node 2 --cmd "rm -rf /mnt/test_md"
    DNF_REMOVE 2 "$@"
    REMOTE_REBOOT 2 60
    LOG_INFO "End to restore the test environment."
}

main "$@"
