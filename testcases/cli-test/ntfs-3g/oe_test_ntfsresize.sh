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
# @Desc      :   verify the uasge of ntfsresize command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL ntfs-3g
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ntfsresize --help 2>&1 | grep "Usage: ntfsresize \[OPTIONS\]"
    CHECK_RESULT $?
    ntfsresize --version 2>&1 | grep "ntfsresize v"
    CHECK_RESULT $?
    ntfsresize --check /dev/vdb
    CHECK_RESULT $?
    ntfsresize --info /dev/vdb | grep "Device name"
    CHECK_RESULT $?
    ntfsresize --info-mb-only /dev/vdb
    CHECK_RESULT $?
    expect <<EOF
    spawn ntfsresize --size 5G /dev/vdb
    expect "Are you sure you want to proceed*"
    send "y\n"
    expect eof
EOF
    CHECK_RESULT $?
    ntfsresize --expand /dev/vdb | grep "ntfsresize"
    CHECK_RESULT $?
    ntfsresize --no-action /dev/vdb --force
    CHECK_RESULT $?
    expect <<EOF
    spawn ntfsresize --bad-sectors /dev/vdb --force
    expect "Are you sure you want to proceed*"
    send "y\n"
    expect eof
EOF
    CHECK_RESULT $?
    ntfsresize --no-progress-bar /dev/vdb --force
    CHECK_RESULT $?
    ntfsresize --verbose /dev/vdb --force
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main $@
