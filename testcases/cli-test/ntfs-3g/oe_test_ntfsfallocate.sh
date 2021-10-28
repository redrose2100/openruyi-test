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
# @Desc      :   verify the uasge of ntfsfallocate command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL ntfs-3g
    mkdir -p /mnt/windows
    ntfs-3g /dev/vdb /mnt/windows
    touch /mnt/windows/database.db
    umount /mnt/windows
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ntfsfallocate -h 2>&1 | grep "Usage: ntfsfallocate \[options\]"
    CHECK_RESULT $?
    ntfsfallocate -V 2>&1 | grep "ntfsfallocate v"
    CHECK_RESULT $?
    ntfsfallocate -l 100M /dev/vdb database.db | grep "ntfsfallocate completed successfully"
    CHECK_RESULT $?
    ntfsfallocate -l 101M /dev/vdb database.db -f | grep "ntfsfallocate completed successfully"
    CHECK_RESULT $?
    ntfsfallocate -l 102M /dev/vdb database.db -n | grep "ntfsfallocate completed successfully"
    CHECK_RESULT $?
    ntfsfallocate -l 103M /dev/vdb database.db -o 1 | grep "ntfsfallocate completed successfully"
    CHECK_RESULT $?
    ntfsfallocate -l 104M /dev/vdb database.db -v | grep "ntfsfallocate completed successfully"
    CHECK_RESULT $?
    ntfsfallocate -l 105M /dev/vdb database.db -vv | grep "ntfsfallocate completed successfully"
    CHECK_RESULT $?
    ntfsfallocate -l 106M /dev/vdb database.db 256 | grep "ntfsfallocate completed successfully"
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    ntfs-3g /dev/vdb /mnt/windows
    rm -rf /mnt/windows/*
    umount /mnt/windows
    rm -rf /mnt/windows
    LOG_INFO "Finish restoring the test environment."
}

main $@
