#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yanglang
# @Contact   :   yanglang@uniontech.com
# @Date      :   2026-04-20
# @License   :   Mulan PSL v2
# @Desc      :   libjpeg-turbo encoding and decoding test
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# 测试前置准备：安装依赖、生成测试文件
function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL libjpeg-turbo
    DNF_INSTALL libjpeg-turbo-devel
    DNF_INSTALL libjpeg-turbo-utils
    DNF_INSTALL gcc
    DNF_INSTALL glibc-devel

    # 用Python生成标准、有效的PGM灰度图（100%兼容cjpeg）
    python3 - << 'EOF'
with open("test.pgm", "wb") as f:
    # PGM文件头
    f.write(b"P5\n32 32\n255\n")
    # 生成32x32的渐变灰度数据（有效数据，非全0）
    data = bytes([min(i, 255) for i in range(32*32)])
    f.write(data)
EOF
    CHECK_RESULT $? 0 0 "Generate test.pgm failed!"
    LOG_INFO "End of environmental preparation!"
}

# 执行测试：编码、解码、版本校验
function run_test() {
    LOG_INFO "start to run test."
    # PGM 转 JPG（编码）
    cjpeg -quality 80 -outfile test.jpg test.pgm
    CHECK_RESULT $? 0 0 "cjpeg encode file failed!"
    
    # JPG 转 PPM（解码）
    djpeg -outfile test.ppm test.jpg
    CHECK_RESULT $? 0 0 "djpeg decode failed!"
    
    # 版本测试 C 代码
    cat > version_test.c <<EOF
#include <stdio.h>
#include <stddef.h>
#include <jpeglib.h>

int main() {
    printf("libjpeg-turbo version: %d\n", JPEG_LIB_VERSION);
    return 0;
}
EOF
    CHECK_RESULT $? 0 0 "Create version_test.c failed!"
    
    # 编译
    gcc version_test.c -o version_test -ljpeg
    CHECK_RESULT $? 0 0 "Compile version_test.c failed!"
    
    # 运行
    ./version_test
    CHECK_RESULT $? 0 0 "Run version_test failed!"
    
    LOG_INFO "All test cases executed successfully!"
}

# 测试后置清理
function post_test()
{
    LOG_INFO "Start to restore the test environment."
    #shellcheck disable=SC2119
    DNF_REMOVE
    rm -rf test.jpg test.pgm test.ppm version_test.c version_test
    LOG_INFO "End to restore the test environment."
}

main "$@"
