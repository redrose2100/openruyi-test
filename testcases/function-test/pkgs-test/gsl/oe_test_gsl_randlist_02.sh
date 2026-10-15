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
# @Author    :   huangdaohong
# @Contact   :   3170809690@qq.com
# @Date      :   2022/08/18
# @License   :   Mulan PSL v2
# @Desc      :   Test gsl-randlist
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gsl"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    gsl-randist 0 10 exponential 1  | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: exponential "
    gsl-randist 0 10 exppow 1 2 | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: exppow "
    gsl-randist 1 10 fdist 10 1 | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: fdist "
    gsl-randist 1 10 flat 10 1 | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: flat "
    gsl-randist 1 10 gamma 10 1 | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: gamma "
    gsl-randist 1 10 gaussian-tail 10 1 | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: gaussian-tail "
    gsl-randist 1 10 gaussian 10  | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: gaussian "
    gsl-randist 1 10 geometric 1 | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: geometric "
    gsl-randist 1 10 gumbel1 1 2  | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: gumbel1 "
    gsl-randist 1 10 gumbel2 1 2  | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: gumbel2 "
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
