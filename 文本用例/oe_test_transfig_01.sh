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
#@Author    :   gaoyue
#@Contact   :   2829807379@qq.com
#@Date      :   2022/8/28
#@License   :   Mulan PSL v2
#@Desc      :   Test "transfig" command
###################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "transfig"
    cp common/arrows.fig ./
    LOG_INFO "End to prepare the test environment"
}
function run_test() {
    LOG_INFO "Start to run testcase:oe_test_tuna."
    fig2dev -L eps arrows.fig | grep -e "% arrowhead"| head -5
    CHECK_RESULT $? 0 0 "L$LINENO: -L No Pass"
    fig2dev -D +50 -L eps arrows.fig | grep -e "% here starts figure with depth 50"
    CHECK_RESULT $? 0 0 "L$LINENO: -D No Pass"
    fig2dev -K -D +50 -L eps arrows.fig | grep -e "BoundingBox"
    CHECK_RESULT $? 0 0 "L$LINENO: -K No Pass"
    fig2dev -L eps arrows.fig -G .25:1cm | grep "% Polyline" | head -5
    CHECK_RESULT $? 0 0 "L$LINENO: -G No Pass"
    fig2dev -j -L eps arrows.fig | grep "% Polyline"| head -5
    CHECK_RESULT $? 0 0 "L$LINENO: -j No Pass"
    fig2dev -m 1.0 -L eps arrows.fig | grep "Polyline" | head -5
    CHECK_RESULT $? 0 0 "L$LINENO: -m No Pass"
    fig2dev -s 11 -L eps arrows.fig | grep "Polyline" | head -5
    CHECK_RESULT $? 0 0 "L$LINENO: -s No Pass"
    fig2dev -Z 500 -L eps arrows.fig | grep "Polyline" | head -5
    CHECK_RESULT $? 0 0 "L$LINENO: -Z No Pass"
    fig2dev -h | grep -E "fig2dev Version|General Options"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    fig2dev -V | grep -e "fig2dev Version"
    CHECK_RESULT $? 0 0 "L$LINENO: -V No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./arrows*
    LOG_INFO "End to restore the test environment."
}

main "$@"
