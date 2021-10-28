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
# @Desc      :   verify the uasge of ntfscp command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL ntfs-3g
    touch test.txt
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ntfscp --help 2>&1 | grep "Usage: ntfscp \[options\]"
    CHECK_RESULT $?
    ntfscp --version 2>&1 | grep "ntfscp v"
    CHECK_RESULT $?
    ntfscp /dev/vdb test.txt test.txt --attribute 256
    CHECK_RESULT $?
    ntfscp /dev/vdb test.txt test.txt --attr-name stream
    CHECK_RESULT $?
    ntfscp /dev/vdb test.txt test.txt --no-action
    CHECK_RESULT $?
    ntfscp /dev/vdb test.txt test.txt --force
    CHECK_RESULT $?
    ntfscp /dev/vdb test.txt test.txt --quiet
    CHECK_RESULT $?
    ntfscp /dev/vdb test.txt test.txt --verbose
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf test.txt
    LOG_INFO "Finish restoring the test environment."
}

main $@
