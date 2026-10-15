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
#@Author    :   liaoyuankun
#@Contact   :   1561203725@qq.com
#@Date      :   2023/10/12
#@License   :   Mulan PSL v2
#@Desc      :   Test "texi2html" command
###################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "texi2html"
    mkdir result
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."

    texi2html -p=1000 -o=result/pinum.html common/test && find . -name "pinum.html" | grep "pinum.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -p No Pass"

    texi2html -p=none -o=result/pin.html common/test && find . -name "pin.html" | grep "pin.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -p No Pass"

    texi2html -p=asis -o=result/pia.html common/test && find . -name "pia.html" | grep "pia.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -p No Pass"

    texi2html -f=72 -o=result/fillcolumn.html common/test && find . -name "fillcolumn.html" | grep "fillcolumn.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf result
    LOG_INFO "End to restore the test environment."
}

main "$@"
