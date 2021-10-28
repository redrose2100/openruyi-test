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
# @Desc      :   verify the uasge of mkntfs command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL ntfs-3g
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    mkntfs --help 2>&1 | grep "Usage: mkntfs \[options\]"
    CHECK_RESULT $?
    mkntfs --version 2>&1 | grep "mkntfs v"
    CHECK_RESULT $?
    mkntfs --fast /dev/vdb | grep "mkntfs completed successfully"
    CHECK_RESULT $?
    mkntfs --quick /dev/vdb | grep "mkntfs completed successfully"
    CHECK_RESULT $?
    mkntfs --label 5 /dev/vdb | grep "mkntfs completed successfully"
    CHECK_RESULT $?
    mkntfs --enable-compression /dev/vdb | grep "mkntfs completed successfully"
    CHECK_RESULT $?
    mkntfs --no-indexing /dev/vdb | grep "mkntfs completed successfully"
    CHECK_RESULT $?
    mkntfs --no-action /dev/vdb | grep "Running in READ-ONLY mode"
    CHECK_RESULT $?
    mkntfs -f /dev/vdb --cluster-size 512 --sector-size 256 --partition-start 256 --heads 10 --sectors-per-track 16 --mft-zone-multiplier 10 --zero-time --force
    CHECK_RESULT $?
    mkntfs --fast /dev/vdb --quiet
    CHECK_RESULT $?
    mkntfs --fast /dev/vdb --verbose | grep "mkntfs completed successfully"
    CHECK_RESULT $?
    mkntfs --fast /dev/vdb --license | grep "This program"
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main $@
