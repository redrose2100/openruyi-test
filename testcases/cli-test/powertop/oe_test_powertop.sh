#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liliqi
# @Contact   :   liliqi@uniontech.com
# @Date      :   2023.02.08
# @License   :   Mulan PSL v2
# @Desc      :   package powertop test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL powertop
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep powertop
    CHECK_RESULT $? 0 0 "The system does not install powertop"
    powertop --html=htmlfile.html
    grep powertop htmlfile.html
    CHECK_RESULT $? 0 0 "No file or directory"
    powertop --time=1 -C/tmp/1.csv
    ls -l /tmp/1.csv
    CHECK_RESULT $? 0 0 "No file or directory"
    powertop --time=1 -r/tmp/test.html
    ls -l /tmp/test.html
    CHECK_RESULT $? 0 0 "No file or directory"

}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f htmlfile.html /tmp/1.csv  /tmp/test.html
    LOG_INFO "End to restore the test environment."
}

main $@
