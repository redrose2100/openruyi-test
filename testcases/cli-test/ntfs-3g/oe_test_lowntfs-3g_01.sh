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
# @Desc      :   verify the uasge of lowntfs-3g command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL ntfs-3g
    mkdir -p /mnt/windows
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    lowntfs-3g --help 2>&1 | grep "Usage:    lowntfs-3g"
    CHECK_RESULT $?
    lowntfs-3g --version 2>&1 | grep "lowntfs-3g"
    CHECK_RESULT $?
    lowntfs-3g /dev/vdb /mnt/windows -o uid=1000,gid=1000
    CHECK_RESULT $?
    umount /mnt/windows
    lowntfs-3g /dev/vdb /mnt/windows -o umask=0777
    CHECK_RESULT $?
    umount /mnt/windows
    lowntfs-3g /dev/vdb /mnt/windows -o dmask=0777
    CHECK_RESULT $?
    umount /mnt/windows
    lowntfs-3g /dev/vdb /mnt/windows -o usermapping=test.txt
    CHECK_RESULT $?
    umount /mnt/windows
    lowntfs-3g /dev/vdb /mnt/windows -o permissions
    CHECK_RESULT $?
    umount /mnt/windows
    lowntfs-3g /dev/vdb /mnt/windows -o ro
    CHECK_RESULT $?
    umount /mnt/windows
    lowntfs-3g /dev/vdb /mnt/windows -o acl
    CHECK_RESULT $?
    umount /mnt/windows
    lowntfs-3g /dev/vdb /mnt/windows -o inherit
    CHECK_RESULT $?
    umount /mnt/windows
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf /mnt/windows
    LOG_INFO "Finish restoring the test environment."
}

main $@
