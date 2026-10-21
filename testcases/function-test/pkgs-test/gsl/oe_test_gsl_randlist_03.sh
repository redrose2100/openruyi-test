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
    gsl-randist 0 10 hypergeometric 6 3 5  | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: hypergeometric "
    gsl-randist 0 10 laplace 1  | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: laplace "
    gsl-randist 1 10 landau | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: landau "
    gsl-randist 1 10 levy 1 2 | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: levy "
    gsl-randist 1 10 levy-skew 1 2 3 | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: levy-skew "
    gsl-randist 1 10 logarithmic 3 | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: logarithmic "
    gsl-randist 1 10 logistic 1  | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: logistic "
    gsl-randist 1 10 lognormal 1 2 | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: lognormal "
    gsl-randist -1 5 negative-binomial -5 -1  | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: negative-binomial "
    gsl-randist 0 5 pareto -5 -1  | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: pareto "
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
