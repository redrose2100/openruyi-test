#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2024/03/05
# @License   :   Mulan PSL v2
# @Desc      :   Basic functional verification of python3_zstd
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libffi libffi-devel gcc clang python3-devel python3-zstd"
    pip install zstandard
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > test.py <<EOF
import zstandard as zstd

# 压缩数据
compressor = zstd.ZstdCompressor()
compressed_data = compressor.compress(b'Your data to compress')

# 解压数据
decompressor = zstd.ZstdDecompressor()
decompressed_data = decompressor.decompress(compressed_data)

print(decompressed_data)
EOF
    test -f test.py
    CHECK_RESULT $? 0 0 " File generation failed"
    python3 test.py |grep compress
    CHECK_RESULT $? 0 0 "Execution failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf test.py
    pip uninstall -y zstandard
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
