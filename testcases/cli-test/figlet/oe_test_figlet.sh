#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2022-04-07
# @License   :   Mulan PSL v2
# @Desc      :   package figlet test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "figlet"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    showfigfonts
    CHECK_RESULT $? 0 0 "Unable to output detailed information"
    chkfont /usr/share/figlet/smscript.flf
    CHECK_RESULT $? 0 0 "Failed to check flf file"
    figlist
    CHECK_RESULT $? 0 0 "Unable to list figlet fonts and control files"
    figlet -f smscript "hello, world!"
    CHECK_RESULT $? 0 0 "Unable to display large letters based on original text"
    figlet -f bubble "hello, world!"
    CHECK_RESULT $? 0 0 "Failed to output information"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment." 
    DNF_REMOVE 
    LOG_INFO "End to restore the test environment."
}

main $@
