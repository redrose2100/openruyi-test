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
#@Desc      	:   create md by rw
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
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    for fs in ${FS_TYPE[@]}; do
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
        mdadm --stop /dev/md0
        echo y | mdadm -C -v /dev/md0 -l 1 -n 2 ${disk_name}1 ${disk_name}2
        CHECK_RESULT $? 0 0 "Create md failed."
        mdadm -Ds | grep /dev/md0
        CHECK_RESULT $? 0 0 "Check md failed."  
        if [[ $fs == "xfs" ]]; then
            mkfs -t $fs -f /dev/md0
        else
            echo y | mkfs -t $fs /dev/md0
        fi
        CHECK_RESULT $? 0 0 "mkfs failed."
        mount /dev/md0 /mnt/test_md -o rw
        CHECK_RESULT $? 0 0 "Mount md failed."
        echo 'test' > /mnt/test_md/testfile
        CHECK_RESULT $? 0 0 "Create file failed."
        cat /mnt/test_md/testfile | grep test
        CHECK_RESULT $? 0 0 "Read file failed."
        umount /dev/md0
        mdadm --stop /dev/md0
        mdadm --misc --zero-superblock ${disk_name}1 ${disk_name}2
        fdisk ${disk_name} << diskEof
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
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"

