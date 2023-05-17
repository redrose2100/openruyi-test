#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2023-03-27
# @License   :   Mulan PSL v2
# @Desc      :   Command test-chsh
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "util-linux-user"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    chsh -h |grep "用法"
    CHECK_RESULT $? 0 0 "Failed to check the display of help information"
    chsh -l |grep bin
    CHECK_RESULT $? 0 0 "Failed to check shell list"
    chsh -s /bin/zsh
    CHECK_RESULT $? 0 0 "Shell change failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    chsh -s /bin/bash
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"



