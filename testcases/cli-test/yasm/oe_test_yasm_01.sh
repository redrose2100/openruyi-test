#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   caowenqian
# @Contact   :   caowenqian@uniontech.com
# @Date      :   2023/11/02
# @License   :   Mulan PSL v2
# @Desc      :   Test yasm function
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "yasm yasm-devel yasm-help"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    yasm --version
    CHECK_RESULT $? 0 0 "check version failed"
    yasm --help
    CHECK_RESULT $? 0 0 "check options failed"
    cat >hello.asm<<EOF
section .data
    hello db 'Hello, World!',0

section .text
    global _start

_start:
    ; write "Hello, World!" to stdout
    mov eax, 4         ; syscall number for sys_write
    mov ebx, 1         ; file descriptor 1 (stdout)
    mov ecx, hello    ; address of the string
    mov edx, 13        ; length of the string
    int 0x80           ; make the syscall

    ; exit the program
    mov eax, 1         ; syscall number for sys_exit
    xor ebx, ebx       ; return code 0
    int 0x80           ; make the syscall
EOF
    test -f hello.asm
    CHECK_RESULT $? 0 0 "Create hello.asm file fail"
    yasm -f elf64 hello.asm -o hello.o
    test -f hello.o
    CHECK_RESULT $? 0 0 "Create hello.o file fail"
    diff hello.o compare.o
    CHECK_RESULT $? 0 0 "hello.o does not match the expected output"
    if [[ $(uname -m) == "x86_64" ]]; then
        ld hello.o -o hello
        test -f hello
        CHECK_RESULT $? 0 0 "Create hello file fail"
        ./hello | grep "Hello, World!"
        CHECK_RESULT $? 0 0 "Execution failed"
    fi
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf hello.asm hello.o hello
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
