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
# @Author    :   fuyahong
# @Contact   :   fuyahong@uniontech.com
# @Date      :   2025-11-19
# @License   :   Mulan PSL v2
# @Desc      :   Test lz4 edge cases (empty files, special chars, etc.)
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "diffutils"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run edge cases test."
    # Test 1: Zero-sized lz4 file
    touch empty_file.txt
    lz4 empty_file.txt empty_file.lz4
    CHECK_RESULT $? 0 0 "Failed to compress empty file"
    test -f empty_file.lz4
    CHECK_RESULT $? 0 0 "Empty file compressed output not found"

    lz4 -d empty_file.lz4 empty_file_decomp.txt
    CHECK_RESULT $? 0 0 "Failed to decompress empty file"
    diff empty_file.txt empty_file_decomp.txt
    CHECK_RESULT $? 0 0 "Empty file decompression mismatch"

    # Test 2: Single character file
    echo "A" > single_char.txt
    lz4 single_char.txt single_char.lz4
    CHECK_RESULT $? 0 0 "Failed to compress single character file"
    
    lz4 -d single_char.lz4 single_char_decomp.txt
    CHECK_RESULT $? 0 0 "Failed to decompress single character file"
    diff single_char.txt single_char_decomp.txt
    CHECK_RESULT $? 0 0 "Single character file decompression mismatch"
    
    # Test 3: File with repeated patterns (zeros)
    dd if=/dev/zero of=zeros.bin bs=1K count=10
    lz4 zeros.bin zeros.lz4
    CHECK_RESULT $? 0 0 "Failed to compress zeros file"
    
    lz4 -d zeros.lz4 zeros_decomp.bin
    CHECK_RESULT $? 0 0 "Failed to decompress zeros file"
    diff zeros.bin zeros_decomp.bin
    CHECK_RESULT $? 0 0 "Zeros file decompression mismatch"
    
    # Test 4: Binary file with random data
    dd if=/dev/urandom of=random.bin bs=1K count=5
    lz4 random.bin random.lz4
    CHECK_RESULT $? 0 0 "Failed to compress random binary file"
    
    lz4 -d random.lz4 random_decomp.bin
    CHECK_RESULT $? 0 0 "Failed to decompress random binary file"
    diff random.bin random_decomp.bin
    CHECK_RESULT $? 0 0 "Random binary file decompression mismatch"
    
    # Test 5: File with special characters in content
    printf "Line 1\\n\\tTab\\tand spaces   \\nLine 3 with unicode: 你好世界\\n" > special_chars.txt
    lz4 special_chars.txt special_chars.lz4
    CHECK_RESULT $? 0 0 "Failed to compress file with special characters"
    
    lz4 -d special_chars.lz4 special_chars_decomp.txt
    CHECK_RESULT $? 0 0 "Failed to decompress file with special characters"
    diff special_chars.txt special_chars_decomp.txt
    CHECK_RESULT $? 0 0 "Special characters file decompression mismatch"
    LOG_INFO "End to run edge cases test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf empty_file* single_char* zeros* random* special_chars* 
    LOG_INFO "End to restore the test environment."
}

main "$@"
