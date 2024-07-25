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
# @Author    :   geyaning
# @Contact   :   geyaning@uniontech.com
# @Date      :   2023/07/12
# @License   :   Mulan PSL v2
# @Desc      :   Compile assembly code into an executable file
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL nasm
    cat >test.asm <<EOL
section .data
msg db "Hello, world!", 0Ah
section .text
global _start
_start:
mov rax, 1
mov rdi, 1
mov rsi, msg
mov rdx, 14
syscall
mov rax, 60
xor rdi, rdi
syscall
EOL
    LOG_INFO "End to prepare the test environment."
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    nasm -f elf64 test.asm -o your_file.o
    test -f your_file.o
    CHECK_RESULT $? 0 0 "Check nasm -f elf64 failed"
    diff your_file.o my_file.o
    CHECK_RESULT $? 0 0 "your_file.o does not match the expected output"

    if [[ $(uname -m) == "x86_64" ]]; then
        ld your_file.o -o your_program
        test -f your_program
        CHECK_RESULT $? 0 0 "Failed to compile assembly code into an executable file"
        ./your_program | grep "Hello, world!"
        CHECK_RESULT $? 0 0 "your_program cannot be executed"
    fi

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf your_program your_file.o test.asm
    DNF_REMOVE "$@"
    LOG_INFO "Een to restore the test environment."
}

main "$@"
