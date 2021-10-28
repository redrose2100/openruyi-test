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
# @Desc      :   verify the uasge of ntfsls command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL ntfs-3g
    mkdir -p /mnt/windows
    ntfs-3g /dev/vdb /mnt/windows
    mkdir /mnt/windows/test
    touch {/mnt/windows/test/test1.txt,/mnt/windows/test/test2.py}
    umount /mnt/windows
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ntfsls --help 2>&1 | grep "Usage: ntfsls \[options\]"
    CHECK_RESULT $?
    ntfsls --version 2>&1 | grep "ntfsls v"
    CHECK_RESULT $?
    ntfsls /dev/vdb --all | grep "test"
    CHECK_RESULT $?
    ntfsls /dev/vdb --classify | grep "test\/"
    CHECK_RESULT $?
    ntfsls /dev/vdb --force | grep "test"
    CHECK_RESULT $?
    ntfsls /dev/vdb --inode
    CHECK_RESULT $?
    ntfsls /dev/vdb --long
    CHECK_RESULT $?
    ntfsls /dev/vdb --path test
    CHECK_RESULT $?
    ntfsls /dev/vdb --quiet --path test
    CHECK_RESULT $?
    ntfsls /dev/vdb --recursive
    CHECK_RESULT $?
    ntfsls /dev/vdb --system
    CHECK_RESULT $?
    ntfsls /dev/vdb --dos --path test
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
