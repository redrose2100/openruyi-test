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
# @Desc      :   verify the uasge of fontforge command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL fontforge
    LOG_INFO "Start to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    fontlint --help | grep "fontlint \[OPTIONS\]"
    CHECK_RESULT $? 0 0 "Check fontlint --help failed"
    fontlint -l 2>&1 | grep 'INFO'
    CHECK_RESULT $? 0 0 "Check fontlint -l failed"
    fontlint --warning ISSUES 2>&1 | grep 'License GPLv3+'
    CHECK_RESULT $? 0 0 "Check fontlint --warning failed"
    fontlint -i common/Duera-CondBlac-PERSONAL.ttf 2>&1 | grep 'parts BSD'
    CHECK_RESULT $? 0 0 "Check fontlint -i failed"
    fontlint -f common/Duera-CondBlac-PERSONAL.ttf 2>&1 | grep 'Based on sources'
    CHECK_RESULT $? 0 0 "Check fontlint -f failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
