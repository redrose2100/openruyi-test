#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wenjun
# @Contact   :   1009065695@qq.com
# @Date      :   2021/10/25
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of ntfsundelete command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL ntfs-3g
    mkdir -p /mnt/windows
    ntfs-3g /dev/vdb /mnt/windows
    touch /mnt/windows/test.txt
    rm -f /mnt/windows/test.txt
    umount /mnt/windows
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ntfsundelete --help 2>&1 | grep "Usage: ntfsundelete \[options\]"
    CHECK_RESULT $?
    ntfsundelete --version 2>&1 | grep "ntfsundelete v"
    CHECK_RESULT $?
    ntfsundelete --scan /dev/vdb --force | grep "test.txt"
    CHECK_RESULT $?
    ntfsundelete --percentage 10 /dev/vdb --force | grep "test.txt"
    CHECK_RESULT $?
    ntfsundelete --match test.txt /dev/vdb --force | grep "test.txt"
    CHECK_RESULT $?
    ntfsundelete --case --match test.txt /dev/vdb --force | grep "test.txt"
    CHECK_RESULT $?
    ntfsundelete --size 0 /dev/vdb --force | grep "test.txt"
    CHECK_RESULT $?
    ntfsundelete --time 2021y /dev/vdb --force | grep "test.txt"
    CHECK_RESULT $?
    ntfsundelete --undelete --match test.txt /dev/vdb --force | grep "Undeleted 'test.txt' successfully to test.txt"
    CHECK_RESULT $?
    ntfsundelete --inode 7 /dev/vdb --force | grep "test.txt"
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf test.txt
    ntfs-3g /dev/vdb /mnt/windows
    rm -rf /mnt/windows/*
    umount /mnt/windows
    rm -rf /mnt/windows
    LOG_INFO "Finish restoring the test environment."
}

main $@
