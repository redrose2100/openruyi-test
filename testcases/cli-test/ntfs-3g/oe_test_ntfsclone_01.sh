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
# @Desc      :   verify the uasge of ntfsclone command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL ntfs-3g
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ntfsclone --help 2>&1 | grep "Usage: ntfsclone \[OPTIONS\]"
    CHECK_RESULT $?
    ntfsclone --version 2>&1 | grep "ntfsclone v"
    CHECK_RESULT $?
    ntfsclone --output test.txt /dev/vdb 2>&1 | grep "Syncing"
    CHECK_RESULT $?
    ntfsclone --overwrite /dev/vda /dev/vdb 2>&1 | grep "Syncing"
    CHECK_RESULT $?
    ntfsclone --save-image --output backup.img /dev/vdb 2>&1 | grep "Syncing"
    CHECK_RESULT $?
    ntfsclone --restore-image --overwrite /dev/vdb backup.img 2>&1 | grep "Syncing"
    CHECK_RESULT $?
    ntfsclone --metadata --output ntfsmeta.img /dev/vdb 2>&1 | grep "Syncing"
    CHECK_RESULT $?
    ntfsclone --overwrite /dev/vda /dev/vdb --rescue 2>&1 | grep "Syncing"
    CHECK_RESULT $?
    ntfsclone --restore-image backup.img --no-action 2>&1 | grep "completed"
    CHECK_RESULT $?
    ntfsclone --metadata --overwrite ntfsmeta.img /dev/vdb --ignore-fs-check 2>&1 | grep "Syncing"
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf test.txt backup.img ntfsmeta.img
    LOG_INFO "Finish restoring the test environment."
}

main $@
