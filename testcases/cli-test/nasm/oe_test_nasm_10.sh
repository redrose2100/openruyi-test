#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of nasm command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL nasm
    touch myfile.asm
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    nasm -w[+-]error=macro-def-case-single myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=macro-def-case-single failed"
    nasm -w[+-]error=macro-def-greedy-single myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=macro-def-greedy-single failed"
    nasm -w[+-]error=macro-def-param-single myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=macro-def-param-single failed"
    nasm -w[+-]error=negative-rep myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=negative-rep failed"
    nasm -w[+-]error=number-overflow myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=number-overflow failed"
    nasm -w[+-]error=obsolete myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=obsolete failed"
    nasm -w[+-]error=obsolete-nop myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=obsolete-nop failed"
    nasm -w[+-]error=obsolete-removed myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=obsolete-removed failed"
    nasm -w[+-]error=obsolete-valid myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=obsolete-valid failed"
    nasm -w[+-]error=phase myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=phase failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf myfile* file nasm* t* imit-*
    DNF_REMOVE
    LOG_INFO "Een to restore the test environment."
}

main $@
