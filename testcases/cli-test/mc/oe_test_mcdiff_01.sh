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
    mcdiff -h 2>&1 | grep 'help'
    CHECK_RESULT $? 0 0 "Check mcdiff -h failed"
    mcdiff --help 2>&1 | grep 'help'
    CHECK_RESULT $? 0 0 "Check mcdiff --help failed"
    mcdiff --help-all 2>&1 | grep 'help'
    CHECK_RESULT $? 0 0 "Check mcdiff --help-all failed"
    mcdiff --help-terminal 2>&1 | grep mcdiff
    CHECK_RESULT $? 0 0 "Check mcdiff --help-terminal failed"
    mcdiff --help-color 2>&1 | grep 'black,'
    CHECK_RESULT $? 0 0 "Check mcdiff --help-color failed"
    mcdiff -V 2>&1 | grep 'GNU Midnight'
    CHECK_RESULT $? 0 0 "Check mcdiff -V  failed"
    mcdiff --version 2>&1 | grep 'GNU Midnight '
    CHECK_RESULT $? 0 0 "Check mcdiff --version  failed"
    mcdiff -F 2>&1 | grep 'Home'
    CHECK_RESULT $? 0 0 "Check mcdiff -F  failed"
    mcdiff --datadir-info 2>&1 | grep 'Home'
    CHECK_RESULT $? 0 0 "Check mcdiff --datadir-info  failed"
    mcdiff --configure-options 2>&1 | grep "'--build="
    CHECK_RESULT $? 0 0 "Check mcdiff --configure-options  failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE mc
    LOG_INFO "Finish restore the test environment."
}

main $@
