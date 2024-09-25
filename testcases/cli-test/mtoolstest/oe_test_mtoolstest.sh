#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhouxinrong
# @Contact   :   zhouxinrong@uniontech.com
# @Date      :   2024-09-02
# @License   :   Mulan PSL v2
# @Desc      :   test mtoolstest
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "mtools"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    mtoolstest
    CHECK_RESULT $? 0 0 "mtoolstest execute fail"
    mtoolstest | grep 'drive'
    CHECK_RESULT $? 0 0 "no drive info is found"
    mtoolstest | grep 'fat_bits'
    CHECK_RESULT $? 0 0 "no fat_bits info is found"
    mtoolstest --version | grep 'mtoolstest'
    CHECK_RESULT $? 0 0 "mtoolstest --version execute fail"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
