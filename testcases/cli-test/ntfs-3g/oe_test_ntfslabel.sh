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
# @Desc      :   verify the uasge of ntfslabel command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL ntfs-3g
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ntfslabel --help 2>&1 | grep "Usage: ntfslabel \[options\]"
    CHECK_RESULT $?
    ntfslabel --version 2>&1 | grep "ntfslabel v"
    CHECK_RESULT $?
    ntfslabel --no-action /dev/vdb 5
    CHECK_RESULT $?
    ntfslabel --force /dev/vdb 5
    CHECK_RESULT $?
    ntfslabel --new-serial /dev/vdb 5 | grep "New serial number"
    CHECK_RESULT $?
    ntfslabel --new-half-serial /dev/vdb 5 | grep "New serial number"
    CHECK_RESULT $?
    ntfslabel --quiet /dev/vdb 5
    CHECK_RESULT $?
    ntfslabel --verbose /dev/vdb 5 | grep "Serial number"
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main $@
