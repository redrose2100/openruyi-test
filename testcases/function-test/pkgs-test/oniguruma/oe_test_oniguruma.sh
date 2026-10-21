#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   changxuqing
# @Contact   :   changxuqing@uniontech.com
# @Date      :   2024/04/29
# @License   :   Mulan PSL v2
# @Desc      :   test oniguruma
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "oniguruma oniguruma-devel"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    onig-config --prefix |grep /usr
    CHECK_RESULT $? 0 0 "prefix fail"
    onig-config --exec-prefix |grep /usr
    CHECK_RESULT $? 0 0 "exec-prefix fail"
    onig-config --libs |grep lonig
    CHECK_RESULT $? 0 0 "libs fail"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"

