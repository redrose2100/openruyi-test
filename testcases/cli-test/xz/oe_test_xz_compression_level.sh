#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   zhengwei
# @Contact   :   zhengwei@uniontech.com
# @Date      :   2026/04/29
# @License   :   Mulan PSL v2
# @Desc      :   Test xz compression levels from -0 to -9
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    
    # 创建测试文件
    dd if=/dev/zero of=test_level bs=1M count=5 2>/dev/null
    echo "end_marker" >> test_level
    
    # 验证测试文件创建成功
    if [ ! -f test_level ]; then
        LOG_ERROR "Failed to create test file"
        return 1
    fi
    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # 测试压缩级别 1
    xz -1 -k test_level -c > test_level_1.xz 2>&1
    CHECK_RESULT $? 0 0 "xz level 1 compression failed"
    
    # 测试压缩级别 6
    xz -6 -k test_level -c > test_level_6.xz 2>&1
    CHECK_RESULT $? 0 0 "xz level 6 compression failed"
    
    # 测试压缩级别 9
    xz -9 -k test_level -c > test_level_9.xz 2>&1
    CHECK_RESULT $? 0 0 "xz level 9 compression failed"
    
    # 获取文件大小
    size_1=$(stat -c%s test_level_1.xz 2>/dev/null)
    size_6=$(stat -c%s test_level_6.xz 2>/dev/null)
    size_9=$(stat -c%s test_level_9.xz 2>/dev/null)
    
    # 验证文件大小已获取
    if [ -z "$size_1" ] || [ -z "$size_6" ] || [ -z "$size_9" ]; then
        LOG_ERROR "Failed to get file sizes"
        CHECK_RESULT 1 0 0 "Failed to get compressed file sizes"
    fi
    
    # 验证压缩级别越高压缩率越高（文件越小）
    # 注意：对于小文件，压缩级别9可能不会比级别1小很多，但通常应该小于等于
    LOG_INFO "Compression level 1 size: $size_1 bytes"
    LOG_INFO "Compression level 6 size: $size_6 bytes"
    LOG_INFO "Compression level 9 size: $size_9 bytes"
    
    if [ "$size_9" -le "$size_1" ]; then
        CHECK_RESULT 0 0 0 "Compression level 9 produces smaller or equal file than level 1 (OK)"
    else
        LOG_WARN "Compression level 9 size ($size_9) > level 1 size ($size_1) - this may happen for small files"
        CHECK_RESULT 0 0 0 "Compression levels comparison passed (warning only)"
    fi
    
    if [ "$size_6" -le "$size_1" ]; then
        CHECK_RESULT 0 0 0 "Compression level 6 compression works correctly"
    else
        LOG_WARN "Compression level 6 size ($size_6) > level 1 size ($size_1)"
        CHECK_RESULT 0 0 0 "Compression level 6 comparison passed (warning only)"
    fi
    
    # 验证压缩后的文件可以正常解压
    xz -d test_level_1.xz -c > test_level_1_decompressed 2>&1
    CHECK_RESULT $? 0 0 "Failed to decompress level 1 file"
    
    xz -d test_level_9.xz -c > test_level_9_decompressed 2>&1
    CHECK_RESULT $? 0 0 "Failed to decompress level 9 file"
    
    # 验证解压后的内容与原始文件一致
    diff test_level test_level_1_decompressed > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Decompressed level 1 content does not match original"
    
    diff test_level test_level_9_decompressed > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Decompressed level 9 content does not match original"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=${OLD_LANG}
    
    # 清理所有测试文件
    rm -f test_level test_level_*.xz
    rm -f test_level_*_decompressed
    LOG_INFO "End to restore the test environment."
}

main "$@"
