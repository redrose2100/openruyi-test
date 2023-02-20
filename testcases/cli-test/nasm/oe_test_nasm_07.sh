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
    nasm -Umacro'str' myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -Umacro failed"
    nasm --pragma 'str' myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -pragma failed"
    nasm --no-line myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm --no-line failed"
    nasm --prefix 'str' myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm --prefix failed"
    nasm --lprefix 'str' myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm --lprefix failed"
    nasm --lpostfix 'str' myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm --lpostfix failed"
    nasm -w+x myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -w+x failed"
    nasm -w-x myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -w-x failed"
    nasm -w[+-]error myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -w[+-]error failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf myfile* file nasm* t* imit-*
    DNF_REMOVE
    LOG_INFO "Een to restore the test environment."
}

main $@
