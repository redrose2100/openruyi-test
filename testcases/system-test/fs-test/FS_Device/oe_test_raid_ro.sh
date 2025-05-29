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
#@Date      	:   2021-06-28
#@License   	:   Mulan PSL v2
#@Desc      	:   create md by ro
#####################################
# shellcheck disable=SC1091,SC2068

source ../common_lib/fsio_lib.sh

function config_params() {
    LOG_INFO "Start to prepare the database config."
    disk_name=$(fdisk -l | grep "Disk /dev/" | grep -vE 'loop|mapper' | awk -F ' |:|：' '{print $2}' | awk 'NR==2')
    LOG_INFO "Finish to prepare the database config."
}

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL mdadm
    mkdir /mnt/test_md
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    if [ "${NODE1_FRAME}" == "riscv64" ]; then
        FS_TYPE="ext3 ext4"
    fi
    for fs in ${FS_TYPE[@]}; do
        fdisk "${disk_name}" <<diskEof
n
p
1

+350M
Y
n
p
2

+350M
Y
w
diskEof
        SLEEP_WAIT 2
        echo y | mdadm -C -v /dev/md0 -l 1 -n 2 "${disk_name}"1 "${disk_name}"2
        CHECK_RESULT $? 0 0 "Create md failed."
        mdadm -Ds | grep /dev/md0
        CHECK_RESULT $? 0 0 "Check md failed."
        if [[ "$fs" == "xfs" ]]; then
            mkfs -t "$fs" -f /dev/md0
        else
            echo y | mkfs -t "$fs" /dev/md0
        fi
        CHECK_RESULT $? 0 0 "mkfs failed."
        mount /dev/md0 /mnt/test_md -o ro
        CHECK_RESULT $? 0 0 "Mount md failed."
        touch /mnt/test_md/testfile 2>&1 | grep 'Read-only file system'
        CHECK_RESULT $? 0 0 "Write file unexpectly."
        mkdir /mnt/test_md/testdir 2>&1 | grep 'Read-only file system'
        CHECK_RESULT $? 0 0 "Create directory unexpectly."
        umount /dev/md0
        mdadm --stop /dev/md0
        mdadm --misc --zero-superblock "${disk_name}"1 "${disk_name}"2
        fdisk "${disk_name}" <<diskEof
d

d

w
diskEof
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /mnt/test_md
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
