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
#@Date      :   2022/8/26
#@License   :   Mulan PSL v2
#@Desc      :   Test "rhino" command
###################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "rhino"
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_rhino_02."
    rhino -? | grep -e "Usage: java org.mozilla.javascript.tools.shell.Main"
    CHECK_RESULT $? 0 0 "L$LINENO: -? No Pass"
    rhino -help | grep -e "Usage: java org.mozilla.javascript.tools.shell.Main"
    CHECK_RESULT $? 0 0 "L$LINENO: -help No Pass"
    rhino -f /usr/share/rhino/enum.js | grep "0.0"
    CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
    rhino -e "var sb = new java.lang.StringBuffer();sb.append('hi, mom');print(sb);" | grep -e "hi, mom"
    CHECK_RESULT $? 0 0 "L$LINENO: -e No Pass"
    LOG_INFO "End to run test."

}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"