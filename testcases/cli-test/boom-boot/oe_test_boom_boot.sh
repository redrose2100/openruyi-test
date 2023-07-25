#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   guheping
#@Contact   :   867559702@qq.com
#@Date      :   2022/8/05
#@License   :   Mulan PSL v2
#@Desc      :   Test "boom-boot" command
###################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "boom-boot"
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_boom_boot."
    ### -h ###
    boom -h | grep "usage: boom"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    ### -b ###
    boom -b 1 profile show
    CHECK_RESULT $? 0 0 "L$LINENO: -b No Pass"
    ### --boot-dir ###
    boom --boot-dir ./ profile show
    CHECK_RESULT $? 0 0 "L$LINENO: --boot-dir No Pass"
    ### --noheadings ###
    boom --noheadings profile show
    CHECK_RESULT $? 0 0 "L$LINENO: --noheadings No Pass"
    ### -H ###
    boom -H profile show
    CHECK_RESULT $? 0 0 "L$LINENO: -H No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"