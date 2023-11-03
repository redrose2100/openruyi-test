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
    gsl-randist 2 10 pascal 0.1 6  | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: pascal "
    gsl-randist 2 10 poisson 1  | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: poisson "
    gsl-randist 1 10 rayleigh-tail 1 2 | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: rayleigh-tail "
    gsl-randist 1 10 rayleigh 1  | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: rayleigh "
    gsl-randist 1 10 tdist 1  | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: tdist "
    gsl-randist 1 10 ugaussian-tail 1 | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: ugaussian-tail "
    gsl-randist 1 10 ugaussian | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: ugaussian "
    gsl-randist 1 10 weibull 1 2 | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: weibull "
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
