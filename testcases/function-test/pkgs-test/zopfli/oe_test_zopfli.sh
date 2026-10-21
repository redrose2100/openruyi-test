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
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2025/11/03
# @License   :   Mulan PSL v2
# @Desc      :   test zopfli
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "zopfli gzip"
    echo "This is a test file for zopfli compression" > test.txt
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    
    zopfli test.txt
    CHECK_RESULT $? 0 0 "Basic compression execution failed"
    
    zopfli --gzip test.txt
    CHECK_RESULT $? 0 0 "Failed to specify output gz format"
    
    zopfli --zlib test.txt
    CHECK_RESULT $? 0 0 "Failed to specify output zlib format"
    
    zopfli --deflate test.txt
    CHECK_RESULT $? 0 0 "Failed to specify output deflate format"
    
    LOG_INFO "Test point 1: Verify decompression integrity"
    original_md5=$(md5sum test.txt | awk '{print $1}')
    
    zopfli --i5 test.txt
    CHECK_RESULT $? 0 0 "Compression with iterations failed"
    
    gunzip -c test.txt.gz > test_decompressed.txt
    CHECK_RESULT $? 0 0 "Failed to decompress gzip file"
    
    decompressed_md5=$(md5sum test_decompressed.txt | awk '{print $1}')
    [[ "$original_md5" == "$decompressed_md5" ]]
    CHECK_RESULT $? 0 0 "Decompressed file content does not match original"
    
    LOG_INFO "Test point 2: Test different compression levels"
    
    zopfli test.txt
    default_size=$(stat -c%s test.txt.gz 2>/dev/null || echo "0")
    
    rm -f test.txt.gz
    zopfli --i15 test.txt
    CHECK_RESULT $? 0 0 "Compression with 15 iterations failed"
    high_compression_size=$(stat -c%s test.txt.gz 2>/dev/null || echo "0")
    
    if [[ $default_size -gt 0 && $high_compression_size -gt 0 ]]; then
        LOG_INFO "Default compression size: ${default_size} bytes"
        LOG_INFO "High compression size: ${high_compression_size} bytes"
        [[ $high_compression_size -le $default_size ]]
        CHECK_RESULT $? 0 0 "Higher iteration count did not improve compression"
    else
        CHECK_RESULT 1 0 0 "Failed to get file sizes for compression comparison"
    fi
    
    LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  # shellcheck disable=SC2119
  DNF_REMOVE
  rm -rf test.txt test.txt.deflate test.txt.gz test.txt.zlib test_decompressed.txt
  LOG_INFO "Finish environment cleanup!"
}

main "$@"


