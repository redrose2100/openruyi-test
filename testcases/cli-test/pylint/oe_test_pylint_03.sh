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
#@Author    :   guheping
#@Contact   :   867559702@qq.com
#@Date      :   2022/12/05
#@License   :   Mulan PSL v2
#@Desc      :   Test "pylint" command
###################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "pylint"
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."
    pylint --list-msgs | grep "name"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --list-msgs No Pass"
    pylint --list-msgs-enabled | grep "Enabled messages:"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --list-msgs-enabled No Pass"
    pylint --list-groups | grep "async"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --list-groups No Pass"
    pylint --list-conf-levels | grep "HIGH"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --list-conf-levels No Pass"
    pylint --list-extensions | grep "pylint.extensions.docstyle"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --list-extensions No Pass"
    pylint --full-documentation | grep "Pylint global options and switches"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --full-documentation No Pass"
    pylint --generate-rcfile >pylint.conf
    find . -name "pylint.conf" | grep "pylint.conf"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --generate-rcfile No Pass"
    pylint --confidence=INFERENCE_FAILURE ./common/test.py | grep "Your code has been rated at"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --confidence <levels> No Pass"
    pylint -e C0103 ./common/test.py | grep "Module test"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint -e <msg ids> No Pass"
    pylint --enable=C0103 ./common/test.py | grep "Module test"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --enable <msg ids> No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f pylint.conf
    LOG_INFO "End to restore the test environment."
}

main "$@"
