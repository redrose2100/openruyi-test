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
# @Author    :   sunqingwei 
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2023/04/03
# @License   :   Mulan PSL v2
# @Desc      :   diffutils advanced parameter
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "diffutils"
    path=/tmp/test
    mkdir -p ${path}
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo "aaa" > ${path}/test1
    echo "AAA" > ${path}/test2
    diff -i ${path}/test1 ${path}/test2
    CHECK_RESULT $? 0 0 "diff -i check failed"
    echo "aaa" > ${path}/test1
    echo "aaa " > ${path}/test2
    diff ${path}/test1 ${path}/test2
    CHECK_RESULT $? 0 1 "diff file test fail"
    diff -Z ${path}/test1 ${path}/test2
    CHECK_RESULT $? 0 0 "diff -Z check failed"
    diff -b ${path}/test1 ${path}/test2
    CHECK_RESULT $? 0 0 "diff -b check failed"
    diff -w ${path}/test1 ${path}/test2
    CHECK_RESULT $? 0 0 "diff -w check failed 1"
    echo >> ${path}/test2
    diff ${path}/test1 ${path}/test2
    CHECK_RESULT $? 0 1 "diff file test failed"
    diff -w -B ${path}/test1 ${path}/test2
    CHECK_RESULT $? 0 0 "diff -w check failed 2"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ${path}
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main "$@"

