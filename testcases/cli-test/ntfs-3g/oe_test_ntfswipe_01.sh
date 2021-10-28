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
# @Desc      :   verify the uasge of ntfswipe command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL ntfs-3g
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ntfswipe --help 2>&1 | grep "Usage: ntfswipe \[options\]"
    CHECK_RESULT $?
    ntfswipe --version 2>&1 | grep "ntfswipe v"
    CHECK_RESULT $?
    ntfswipe --info /dev/vdb
    CHECK_RESULT $?
    ntfswipe --directory /dev/vdb
    CHECK_RESULT $?
    ntfswipe --logfile /dev/vdb
    CHECK_RESULT $?
    ntfswipe --mft /dev/vdb
    CHECK_RESULT $?
    ntfswipe --pagefile /dev/vdb
    CHECK_RESULT $?
    ntfswipe --tails /dev/vdb
    CHECK_RESULT $?
    ntfswipe --unused /dev/vdb
    CHECK_RESULT $?
    ntfswipe --unused-fast /dev/vdb
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main $@
