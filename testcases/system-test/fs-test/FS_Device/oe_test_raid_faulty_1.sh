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
#@Date      	:   2021-07-02
#@License   	:   Mulan PSL v2
#@Desc      	:   Set one of devices on raid1 is faulty
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to prepare the database config."
    free_disk=$(lsblk | grep disk | awk '{print $1}' | tail -n 1)
    disk_name="/dev/"$free_disk
    LOG_INFO "Finish to prepare the database config."
}

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL mdadm
    mkdir /mnt/test_md
    fdisk ${disk_name} << diskEof
n
p
1

100000
n
p
2

200000
w
diskEof
    echo y | mdadm -C /dev/md0 -l 1 -n 2 ${disk_name}1 ${disk_name}2
    echo y | mkfs -t ext4 /dev/md0
    mount /dev/md0 /mnt/test_md
    echo test1 > /mnt/test_md/testfile1
    echo test2 > /mnt/test_md/testfile2
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    mdadm /dev/md0 -f ${disk_name}2
    CHECK_RESULT $? 0 0 "Set ${disk_name}2 faulty failed."
    grep test1 /mnt/test_md/testfile1
    CHECK_RESULT $? 0 0 "Check file failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    umount /dev/md0
    mdadm --stop /dev/md0
    rm -rf /mnt/test_md
    mdadm --misc --zero-superblock ${disk_name}1 ${disk_name}2
    fdisk ${disk_name} << diskEof
d

d

w
diskEof
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"

