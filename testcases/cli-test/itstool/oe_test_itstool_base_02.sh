#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   linian
# @Contact   :   1173417216@qq.com
# @Date      :   2022/09/30
# @License   :   Mulan PSL v2
# @Desc      :   Test itstool
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "itstool"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    itstool -k common/IT-keep-entities-1.ll.xml | grep 'historia'
    CHECK_RESULT $? 0 0 "itstool -k failed"
    itstool --keep-entities common/IT-keep-entities-1.ll.xml | grep 'historia'
    CHECK_RESULT $? 0 0 "itstool --keep-entities failed"
    itstool common/test-p.xml -p param_name value2 | grep 'value2'
    CHECK_RESULT $? 0 0 "itstool -p failed"
    itstool common/test-p.xml --param param_name value2 | grep 'value2'
    CHECK_RESULT $? 0 0 "itstool --param failed"
    itstool -t translate common/translate.xml | grep 'translate'
    CHECK_RESULT $? 0 0 "itstool -t failed"
    itstool --test=translate common/translate.xml | grep 'translate'
    CHECK_RESULT $? 0 0 "itstool --test failed"
    itstool --version | grep "itstool [[:digit:]]"
    CHECK_RESULT $? 0 0 "itstool --version failed"
    itstool -v | grep "itstool [[:digit:]]"
    CHECK_RESULT $? 0 0 "itstool -v failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"