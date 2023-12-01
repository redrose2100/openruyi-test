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
# @Author    :   wangpeng
# @Contact   :   wangpengb@uniontech.com
# @Date      :   2023/02/14
# @License   :   Mulan PSL v2
# @Desc      :   test diffutils
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "diffutils"
    path=/tmp/test
    mkdir -p ${path}
    echo "aaa" > ${path}/test1
    echo "aab" > ${path}/test2
    cp ${path}/test1 ${path}/test3
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    diff -s ${path}/test1 ${path}/test3 | grep -E "identical|相同"
    CHECK_RESULT $? 0 0 "same files check failed"
    diff ${path}/test1 ${path}/test2
    CHECK_RESULT $? 0 1 "different files check failed"
    diff ${path}/test1 ${path}/test2 | grep "aaa"
    CHECK_RESULT $? 0 0 "different files check words failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ${path}
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main "$@"

