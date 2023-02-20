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
    nasm -f dbg myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -f dbg failed"
    nasm -f elf myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -f elf failed"
    nasm -f macho myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -f macho failed"
    nasm -f win myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -f win failed"
    nasm -g myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -g failed"
    nasm myfile.asm -f elf -g -F stabs
    CHECK_RESULT $? 0 0 "Check nasm -F stabs failed"
    nasm -f elf -g -F dwarf myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -F dwarf failed"
    nasm -f coff myfile.asm -l myfile.lst && test -f myfile.lst
    CHECK_RESULT $? 0 0 "Check nasm -l failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf myfile* file nasm* t* imit-*
    DNF_REMOVE
    LOG_INFO "Een to restore the test environment."
}

main $@
