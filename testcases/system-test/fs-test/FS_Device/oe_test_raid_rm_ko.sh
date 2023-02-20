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
#@Date      	:   2021-06-29
#@License   	:   Mulan PSL v2
#@Desc      	:   Add and remove mode for md
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to prepare the database config."
    free_disk=$(lsblk | grep disk | awk '{print $1}' | tail -n 1)
    disk_name="/dev/"$free_disk
    kernel_version=$(ls -l /usr/lib/modules | awk '{print $9}' | tail -n 1)
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
Y
n
p
2

200000
Y
w
diskEof
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    for i in {1..50}; do 
        rmmod raid1
        CHECK_RESULT $? 0 0 "Remove mode failed."
        insmod /usr/lib/modules/${kernel_version}/kernel/drivers/md/raid1.ko
        CHECK_RESULT $? 0 0 "Add mode failed."
        echo y | mdadm -C -v /dev/md0 -l 1 -n 2 ${disk_name}1 ${disk_name}2
        echo y | mkfs -t ext4 /dev/md0
        mount /dev/md0 /mnt/test_md
        echo $i > /mnt/test_md/testfile$i
        CHECK_RESULT $? 0 0 "Write file failed."
        grep $i /mnt/test_md/testfile$i
        CHECK_RESULT $? 0 0 "Read file failed."
        umount /dev/md0
        mdadm --stop /dev/md0
    done 

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /mnt/test_md
    mdadm --misc --zero-superblock ${disk_name}1
    mdadm --misc --zero-superblock ${disk_name}2
    fdisk ${disk_name} << diskEof
d

d

w
diskEof
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"

