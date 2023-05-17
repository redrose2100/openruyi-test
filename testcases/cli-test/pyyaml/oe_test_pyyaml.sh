#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023-03-28
# @License   :   Mulan PSL v2
# @Desc      :   pyyaml function verification
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "python3-pyyaml"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    python3 test.py
    CHECK_RESULT $? 0 0 "Execution failed"
    ls generate.yaml
    CHECK_RESULT $? 0 0 "file does not exist"
    grep 'school: zhang' generate.yaml
    CHECK_RESULT $? 0 0 "Keyword not matched"
    python3 test2.py |grep students |grep a | grep b
    CHECK_RESULT $? 0 0 "Conversion to dictionary failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f generate.yaml
    LOG_INFO "End to restore the test environment."
}

main "$@"
