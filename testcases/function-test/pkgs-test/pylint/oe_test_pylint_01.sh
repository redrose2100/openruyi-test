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
    DNF_INSTALL "pylint bc"
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."
    pylint -h | grep "Usage\|usage"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    pylint --long-help | grep "Usage\|usage"
    CHECK_RESULT $? 0 0 "L$LINENO: -long-help No Pass"
    pylint --init-hook='import sys; import os; sys.path.append(os.getcwd())' ./common/test.py | grep "Module test"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --init-hook <code> No Pass"
    pylint -E ./common/test_error.py | grep "Module test"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint -E No Pass"
    v1=$(rpm -qa pylint | awk -F- '{print $2}' | awk -F. '{print $1}')
    v2=$(rpm -qa pylint | awk -F- '{print $2}' | awk -F. '{print $2}')
    v3=$(rpm -qa pylint | awk -F- '{print $2}' | awk -F. '{print $3}')
    if [ "$v1" -lt 2 ] || [ "$v1" -eq 2 ] && [ "$v2" -lt 12 ] || [ "$v1" -eq 2 ] && [ "$v2" -eq 12 ] && [ "$v3" -lt 2 ]; then
        pylint --py3k ./common/test.py | grep "Your code has been rated at"
        CHECK_RESULT $? 0 0 "L$LINENO: pylint --py3k No Pass"
    else
        LOG_INFO "This version does not have this parameter."
    fi
    pylint -v ./common/test.py | grep "Module test"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint -v No Pass"
    pylint --verbose ./common/test.py | grep "Module test"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --verbose No Pass"
    pylint --ignore=CVS --generate-rcfile | grep "ignore=CVS"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --ignore No Pass"
    pylint --ignore-patterns test.py --generate-rcfile | grep "ignore-patterns=test.py"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --ignore-patterns No Pass"
    pylint --persistent=n --generate-rcfile | grep "persistent=no"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --persistent <y_or_n> No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
