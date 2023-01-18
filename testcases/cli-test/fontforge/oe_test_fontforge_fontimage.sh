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
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    fontimage --version 2>&1 | grep "Version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check fontimage --version failed"
    fontimage --width 10 common/Duera-CondBlac-PERSONAL.ttf
    CHECK_RESULT $? 0 0 "Check fontimage --width failed"
    fontimage --height 10 common/Duera-CondBlac-PERSONAL.ttf
    CHECK_RESULT $? 0 0 "Check fontimage --height failed"
    fontimage --fontname common/Duera-CondBlac-PERSONAL.ttf
    CHECK_RESULT $? 0 0 "Check fontimage --fontname failed"
    fontimage --text "string" common/Duera-CondBlac-PERSONAL.ttf
    CHECK_RESULT $? 0 0 "Check fontimage --text failed"
    fontimage --pixelsize 100 common/Duera-CondBlac-PERSONAL.ttf
    CHECK_RESULT $? 0 0 "Check fontimage --pixelsize failed"
    fontimage --o Duera-CondBlac.png common/Duera-CondBlac-PERSONAL.ttf
    CHECK_RESULT $? 0 0 "Check fontimage --o failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
