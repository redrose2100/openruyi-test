#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL gsl
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    gsl-randist | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: gsl-randist"
    gsl-randist 0 10 beta 1 2 | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: beta "
    gsl-randist 1 10 binomial 0.5 10 | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: binomial "
    gsl-randist 1 10 bivariate-gaussian 0.5 10 1 | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: bivariate-gaussian "
    gsl-randist 1 10 cauchy 10 | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: cauchy "
    gsl-randist 1 10 chisq 10  | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: chisq "
    gsl-randist 1 10 dir-2d 10 | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: dir-2d "
    gsl-randist 1 10 dir-3d 10  | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: dir-3d "
    gsl-randist 1 10 dir-nd 10 | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: dir-nd "
    gsl-randist 1 10 erlang 1 2  | grep '[0-9]'
    CHECK_RESULT $? 0 0 "Failed option: erlang "
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
