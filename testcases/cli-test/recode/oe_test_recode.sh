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
# @Author    :   huangcan
# @Contact   :   huangcan@uniontech.com
# @Date      :   2024-09-03
# @License   :   Mulan PSL v2
# @Desc      :   test recode
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment!"
    DNF_INSTALL "recode"
    LOG_INFO "End to prepare the test environment!"
}

function run_test() {
    LOG_INFO "Start testing..."
    recode --help
    CHECK_RESULT $? 0 0 "recode install fail"
    recode -l | more
    CHECK_RESULT $? 0 0 "recode execute fail"
    touch page.txt
    echo "Hello, World!" > page.txt
    recode ..HTML <page.txt> page.html
    CHECK_RESULT $? 0 0 "recode execute fail"
    cat page.html
    CHECK_RESULT $? 0 0 "page.html generation failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf page.txt
    rm -rf page.html
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"