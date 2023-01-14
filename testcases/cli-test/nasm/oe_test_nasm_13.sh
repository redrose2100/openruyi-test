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
    nasm -f macho32 myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -f macho32 failed"
    nasm --reproducible myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm --reproducible failed"
    nasm -w[+-]error=macro-defaults myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=other failed"
    nasm -w[+-]error=macro-params myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=macro-params failed"
    nasm -w[+-]error=macro-params-legacy myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=macro-params-legacy failed"
    nasm -w[+-]error=macro-params-multi myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=macro-params-multi failed"
    nasm -w[+-]error=macro-params-single myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=macro-params-single failed"
    nasm --before move myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm nasm --before failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf myfile* file nasm* t* imit-*
    DNF_REMOVE
    LOG_INFO "Een to restore the test environment."
}

main $@
