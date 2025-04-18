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
#@Desc      	:   Compress to system and act md
#####################################
# shellcheck disable=SC1090,SC2034

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to prepare the database config."
    EXECUTE_T="60m"
    disk_name=$(fdisk -l | grep "Disk /dev/" | grep -vE 'loop|mapper' | awk -F ' |:|：' '{print $2}' | awk 'NR==2')
    LOG_INFO "Finish to prepare the database config."
}

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL "mdadm gcc kernel-devel"
    mkdir /mnt/test_md
    fdisk "${disk_name}" <<diskEof
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
    echo y | mdadm -C -v /dev/md1 -l 1 -n 2 "${disk_name}"1 "${disk_name}"2
    echo y | mkfs -t ext4 /dev/md1
    mount /dev/md1 /mnt/test_md
    cd ../common_lib/fault_injection/inject_mem_overloading_kmalloc || exit
    bash inject_mem_overloading_kmalloc.sh inject
    cd - || exit
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    for i in seq {1..50}; do
        mdadm /dev/md1 -f "${disk_name}"2
        CHECK_RESULT $? 0 0 "Set ${disk_name}2 faulty failed."
        mdadm /dev/md1 -r "${disk_name}"2
        CHECK_RESULT $? 0 0 "Remove ${disk_name}2 faulty failed."
        mdadm /dev/md1 -a "${disk_name}"2
        CHECK_RESULT $? 0 0 "Add ${disk_name}2 faulty failed."
        SLEEP_WAIT 2
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    cd ../common_lib/fault_injection/inject_mem_overloading_kmalloc || exit
    bash inject_mem_overloading_kmalloc.sh clean
    cd - || exit
    umount /dev/md1
    mdadm --stop /dev/md1
    rm -rf /mnt/test_md
    mdadm --misc --zero-superblock "${disk_name}"1 "${disk_name}"2
    fdisk "${disk_name}" <<diskEof
d

d

w
diskEof
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
