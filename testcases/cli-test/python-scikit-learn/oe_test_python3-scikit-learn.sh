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
# @Author    :   zuohanxu
# @Contact   :   zuohanxu@uniontech.com
# @Date      :   2023/08.17
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-python3-scikit-learn,
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "python3-scikit-learn"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    result="[1 0 2 1 1 0 1 2 1 1 2 0 0 0 0 1 2 1 1 2 0 2 0 2 2 2 2 2 0 0]"
    pip3 freeze |grep scikit-learn
    CHECK_RESULT $? 0 0 "python3-scikit-learn installation failure"
    python3 test_scikit-learn.py |grep "${result}"
    CHECK_RESULT $? 0 0 "test python3-scikit-learn fail"
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/test_gdbm
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
