#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of mc command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL mc
    LOG_INFO "Start to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    mcedit --help 2>&1 | grep 'mcedit'
    CHECK_RESULT $? 0 0 "Check mcedit --help failed"
    mcedit -h 2>&1 | grep 'mcedit'
    CHECK_RESULT $? 0 0 "Check mcedit -h failed"
    mcedit --help-all 2>&1 | grep 'mcedit'
    CHECK_RESULT $? 0 0 "Check mcedit --help-all failed"
    mcedit --help-terminal 2>&1 | grep 'GNU Midnight'
    CHECK_RESULT $? 0 0 "Check mcedit --help-terminal failed"
    mcedit --help-color 2>&1 | grep 'black'
    CHECK_RESULT $? 0 0 "Check mcedit --help-color failed"
    mcedit -V 2>&1 | grep 'GNU Midnight Commander '
    CHECK_RESULT $? 0 0 "Check mcedit -V failed"
    mcdiff --version 2>&1 | grep 'GNU Midnight Commander '
    CHECK_RESULT $? 0 0 "Check mcedit --version failed"
    mcedit -F 2>&1 | grep 'Home路径'
    CHECK_RESULT $? 0 0 "Check mcedit -F failed"
    mcedit --datadir-info 2>&1 | grep 'Home'
    CHECK_RESULT $? 0 0 "Check mcedit --datadir-info failed"
    mcedit --configure-options 2>&1 | grep "'--build="
    CHECK_RESULT $? 0 0 "Check mcedit --configure-options  failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "Finish restore the test environment."
}

main $@
