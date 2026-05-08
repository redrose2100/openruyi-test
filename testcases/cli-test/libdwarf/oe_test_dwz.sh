#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   Lufei
# @Contact   :   lufei@uniontech.com
# @Date      :   2025-11-12
# @License   :   Mulan PSL v2
# @Desc      :   Test drawf tool dwz basic functionality
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "dwz gcc"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    local file_size_origin
    local file_size_compressed
    
    # create tst_dwz.c
    cat > tst_dwz.c << eof
#include <stdio.h>
int add(int a, int b) { return a + b; }
int main() { printf("%d\\n", add(2, 3)); return 0; }
eof

    # compile with debug info
    gcc -g tst_dwz.c -o tst_dwz
    CHECK_RESULT $? 0 0 "gcc may failed to create output file" 1

    # check if gcc generated output file
    test -f tst_dwz
    CHECK_RESULT $? 0 0 "gcc may failed to create output file" 1

    # get origin ELF file size (in bytes)
    file_size_origin=$(du -shb tst_dwz | cut -f 1)
    LOG_INFO "origin size: ${file_size_origin}"

    # try to compress
    dwz tst_dwz
    CHECK_RESULT $? 0 0 "dwz compress ELF failed" 1

    file_size_compressed=$(du -shb tst_dwz | cut -f 1)
    LOG_INFO "compressed size: ${file_size_compressed}"

    # test if origin file size greater than compressed file size
    test "$file_size_origin" -gt "$file_size_compressed"
    CHECK_RESULT $? 0 0 "ELF file size not compressed by dwz"
    
    LOG_INFO "End of testcase execution!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf tst_dwz.c tst_dwz
    # shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
