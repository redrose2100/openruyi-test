#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
#@Date      :   2023/10/19
#@License   :   Mulan PSL v2
#@Desc      :   Test "transfig" command
###################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "transfig"
    cp common/arrows.fig ./
    ver=$(rpm -qi transfig | grep -oP 'Version\s+:\s+\K[\d.]+')
    LOG_INFO "End to prepare the test environment"
}
function run_test() {
    LOG_INFO "Start to run test."
    fig2dev -L eps arrows.fig | grep -i 'epsf'
    CHECK_RESULT $? 0 0 "Check fig2dev -L eps arrows.fig failed"
    fig2dev -D +50 -L eps arrows.fig | grep -e "% here starts figure with depth 50"
    CHECK_RESULT $? 0 0 "Check fig2dev -D +50 -L eps arrows.fig failed"
    fig2dev -K -D +50 -L eps arrows.fig | grep -e "BoundingBox"
    CHECK_RESULT $? 0 0 "Check fig2dev -K -D +50 -L eps arrows.fig failed"
    fig2dev -L eps arrows.fig -G .25:1cm | grep "here starts figure with depth 1001"
    CHECK_RESULT $? 0 0 "Check fig2dev -L eps arrows.fig -G .25:1cm failed"
    fig2dev -L eps -j arrows.fig | grep -i 'epsf'
    CHECK_RESULT $? 0 0 "Check fig2dev -j -L eps arrows.fig failed"
    fig2dev -m 2.0 -L eps arrows.fig | grep 'Magnification: 2.0000'
    CHECK_RESULT $? 0 0 "Check fig2dev -m 2.0 -L eps arrows.fig failed"
    fig2dev -s 10 -L eps arrows.fig | grep -i 'epsf'
    CHECK_RESULT $? 0 0 "Check fig2dev -s 10 -L eps arrows.fig failed"
    fig2dev -Z 2 -L eps arrows.fig | grep "BoundingBox: 0 0 145 107"
    CHECK_RESULT $? 0 0 "Check fig2dev -Z 500 -L eps arrows.fig failed"
    fig2dev -h | grep -E "fig2dev Version|General Options"
    CHECK_RESULT $? 0 0 "Check fig2dev -h failed"
    fig2dev -V | grep "fig2dev Version $ver"
    CHECK_RESULT $? 0 0 "Check fig2dev -V failed"
    pic2tpic --help | grep "sed"
    CHECK_RESULT $? 0 0 "Check pic2tpic --help failed"
    pic2tpic --version | grep "sed (GNU sed)"
    CHECK_RESULT $? 0 0 "Check pic2tpic --version failed"
    transfig -h 2>&1 | grep "usage: transfig <option>"
    CHECK_RESULT $? 0 0 "Check transfig -h failed"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf ./arrows*
    LOG_INFO "End to restore the test environment."
}

main "$@"
