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
    touch file.asm
    touch myfile.asm
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    nasm -f aoutb myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -f aoutb failed"
    nasm -f coff myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -f coff failed"
    nasm -f elf32 myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -f elf32 failed"
    nasm -f elf64 myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -f elf64 failed"
    nasm -f elfx32 file.asm
    CHECK_RESULT $? 0 0 "Check nasm -f elfx32 failed"
    nasm -f as86 file.asm
    CHECK_RESULT $? 0 0 "Check nasm -f as86 failed"
    nasm -f obj file.asm
    CHECK_RESULT $? 0 0 "Check nasm -f obj failed"
    nasm -f win32 file.asm
    CHECK_RESULT $? 0 0 "Check nasm -f win32 failed"
    nasm -f win64 file.asm
    CHECK_RESULT $? 0 0 "Check nasm -f win64 failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf myfile* file* nasm* t* imit-*
    DNF_REMOVE
    LOG_INFO "Een to restore the test environment."
}

main $@
