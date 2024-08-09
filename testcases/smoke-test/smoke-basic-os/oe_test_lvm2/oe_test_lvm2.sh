#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   gumengchen
# @Contact   :   gumengchen@huawei.com
# @Date      :   2024-08-06
# @License   :   Mulan PSL v2
# @Desc      :   test arch
# ############################################

shellcheck disable=SC9210
shellcheck disable=SC9215
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment!"
    DNF_INSTALL lvm2
    dd if=/dev/zero of=/tmp/ramdisk bs=1M count=512
    dd if=/dev/zero of=/tmp/ramdisk1 bs=1M count=512
    losetup /dev/loop0 /tmp/ramdisk
    losetup /dev/loop1 /tmp/ramdisk1
    mkfs -t ext4 /dev/loop0
    mkfs -t ext4 /dev/loop1
    version_id=$(grep "VERSION_ID" /etc/os-release | awk -F "=" '{print$NF}' | awk -F "\"" '{print$2}')
    LOG_INFO "End to prepare the test environment!"
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    LOG_INFO "Start to create"
    pvcreate -y /dev/loop0 --setphysicalvolumesize 100MB | grep "successfully created"
    CHECK_RESULT $?
    pvcreate -y /dev/loop0 
    CHECK_RESULT $?
    pvcreate -y /dev/loop1
    CHECK_RESULT $?
    vgcreate test /dev/loop0 /dev/loop1
    CHECK_RESULT $?
    LOG_INFO "Start to change"
    pvchange --addtag gh /dev/loop0
    CHECK_RESULT $?
    
    pvdisplay -C -a | grep "/dev/loop0"
    CHECK_RESULT $?
    # LOG_INFO "Start to move"
    # pvmove -q /dev/loop0 /dev/loop1
    # pvmove -q /dev/loop1 /dev/loop0
    # CHECK_RESULT $?
    LOG_INFO "Start to remove"
    vgreduce test /dev/loop0
    CHECK_RESULT $?
    pvremove -f /dev/loop0
    CHECK_RESULT $?
    pvcreate -y /dev/loop0
    CHECK_RESULT $?
    LOG_INFO "Start to resize"
    pvresize -y /dev/loop1 --setphysicalvolumesize 200MB
    CHECK_RESULT $?
    # pvs | grep "200.00MB"
    # CHECK_RESULT $?
    vgextend test /dev/loop0
    CHECK_RESULT $?
    vgdisplay 

    LOG_INFO "Start to export"
    vgexport test | grep "successfully exported"
    CHECK_RESULT $? 0 0 "failed to export VG test"
    vgimport test 
    CHECK_RESULT $? 0 0 "failed to import VG test"

    LOG_INFO "Start to create LV"
    lvcreate -L 100M -n lv1 test 
    CHECK_RESULT $?
    lvdisplay
    lvextend -L 104M test/lv1
    CHECK_RESULT $?
    lvdisplay | grep lv1

    LOG_INFO "Start to rename"
    vgrename test test1 | grep "successfully renamed"
    CHECK_RESULT $?
    vgs 2>&1 | grep "test1"
    CHECK_RESULT $?
  
    LOG_INFO "End executing testcase!" 
}


function post_test() {
    LOG_INFO "Start environment cleanup."
    lvremove -f test1/lv1
    vgremove -f test1
    pvremove -f /dev/loop0 /dev/loop1
    DNF_REMOVE
    # 删除RAM盘
    losetup -d /dev/loop0
    losetup -d /dev/loop1
    rm -f /tmp/ramdisk
    rm -f /tmp/ramdisk1
    LOG_INFO "Finish environment cleanup."
}

main "$@"