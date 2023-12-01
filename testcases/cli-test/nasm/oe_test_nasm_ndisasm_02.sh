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
    cat >myfile.asm <<EOL
section .data

msg:
     db "Hello World!!", 0ah, 0dh


section .text
     global main

main:

     mov eax, 4
     mov ebx, 1
     mov ecx, msg
     mov edx, 14
     int 80h

     mov eax, 1
     int 80h

EOL
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ndisasm -p amd myfile.asm 2>&1 | grep 'jnc'
    CHECK_RESULT $? 0 0 "Check ndisasm -p failed"
    ndisasm -o 100H myfile.asm 2>&1 | grep 'jnc'
    CHECK_RESULT $? 0 0 "Check ndisasm -o failed"
    ndisasm -s 120H myfile.asm 2>&1 | grep 'jnc'
    CHECK_RESULT $? 0 0 "Check ndisasm -o failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf myfile.*
    DNF_REMOVE
    LOG_INFO "Finish restore the test environment."
}

main $@
