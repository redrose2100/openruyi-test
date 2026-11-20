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
# @Desc      :   Test lz4 compression levels (-1 to -9, --fast, --best)
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "diffutils"
    # Create test data files
    echo "This is test data for compression level testing" > test_data.txt
    dd if=/dev/urandom of=test_random.bin bs=1K count=10
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run compression levels test."
    # Test compression level 1 (fastest)
    lz4 -1 test_data.txt test_data_l1.lz4
    CHECK_RESULT $? 0 0 "Failed to compress with level 1"
    test -f test_data_l1.lz4
    CHECK_RESULT $? 0 0 "Level 1 compressed file not found"
    
    # Test compression level 9 (best)
    lz4 -9 test_data.txt test_data_l9.lz4
    CHECK_RESULT $? 0 0 "Failed to compress with level 9"
    test -f test_data_l9.lz4
    CHECK_RESULT $? 0 0 "Level 9 compressed file not found"
    
    # Test --fast flag
    lz4 --fast test_data.txt test_data_fast.lz4
    CHECK_RESULT $? 0 0 "Failed to compress with --fast"
    test -f test_data_fast.lz4
    CHECK_RESULT $? 0 0 "Fast compressed file not found"
    
    # Test --best flag
    lz4 --best test_data.txt test_data_best.lz4
    CHECK_RESULT $? 0 0 "Failed to compress with --best"
    test -f test_data_best.lz4
    CHECK_RESULT $? 0 0 "Best compressed file not found"
    
    # Test decompression of all levels
    lz4 -d test_data_l1.lz4 test_data_l1_decomp.txt
    CHECK_RESULT $? 0 0 "Failed to decompress level 1 file"
    
    lz4 -d test_data_l9.lz4 test_data_l9_decomp.txt
    CHECK_RESULT $? 0 0 "Failed to decompress level 9 file"
    
    lz4 -d test_data_fast.lz4 test_data_fast_decomp.txt
    CHECK_RESULT $? 0 0 "Failed to decompress fast file"
    
    lz4 -d test_data_best.lz4 test_data_best_decomp.txt
    CHECK_RESULT $? 0 0 "Failed to decompress best file"
    
    # Verify data integrity
    diff test_data.txt test_data_l1_decomp.txt
    CHECK_RESULT $? 0 0 "Level 1 decompressed data mismatch"
    
    diff test_data.txt test_data_l9_decomp.txt
    CHECK_RESULT $? 0 0 "Level 9 decompressed data mismatch"
    
    diff test_data.txt test_data_fast_decomp.txt
    CHECK_RESULT $? 0 0 "Fast decompressed data mismatch"
    
    diff test_data.txt test_data_best_decomp.txt
    CHECK_RESULT $? 0 0 "Best decompressed data mismatch"
    
    # Test with binary data
    lz4 -5 test_random.bin test_random_l5.lz4
    CHECK_RESULT $? 0 0 "Failed to compress binary with level 5"
    
    lz4 -d test_random_l5.lz4 test_random_l5_decomp.bin
    CHECK_RESULT $? 0 0 "Failed to decompress binary file"
    
    diff test_random.bin test_random_l5_decomp.bin
    CHECK_RESULT $? 0 0 "Binary data decompression mismatch"
    LOG_INFO "End to run compression levels test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf test_data* test_random*
    LOG_INFO "End to restore the test environment."
}

main "$@"
