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
# @Date      :   2025/11/06
# @License   :   Mulan PSL v2
# @Desc      :   test zopflipng
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "zopfli ImageMagick"
    convert -size 100x100 xc:red test1.png
    # 创建更复杂的测试图片用于更好的压缩测试
    convert -size 200x200 gradient:blue-red gradient.png
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    zopflipng test1.png optimized1.png
    CHECK_RESULT $? 0 0 "Basic compression execution failed"
    zopflipng -q test1.png fast.png
    CHECK_RESULT $? 0 0 "Failed to execute fast compression"
    zopflipng -m test1.png more_compressed.png 
    CHECK_RESULT $? 0 0 "More compression failed to execute"
    zopflipng --iterations=5 test1.png iter5.png
    CHECK_RESULT $? 0 0 "Compression failed to execute the specified number of iterations"
    
    # 新增测试点1：验证PNG压缩的无损特性
    LOG_INFO "Test point 1: Verify lossless compression of PNG"
    
    # 使用ImageMagick比较压缩前后图片的像素数据
    original_pixels=$(convert test1.png -depth 8 txt:- | md5sum | awk '{print $1}')
    compressed_pixels=$(convert optimized1.png -depth 8 txt:- | md5sum | awk '{print $1}')
    
    [[ "$original_pixels" == "$compressed_pixels" ]]
    CHECK_RESULT $? 0 0 "PNG compression is not lossless - pixel data changed"
    
    # 新增测试点2：验证压缩效果和尺寸不变性
    LOG_INFO "Test point 2: Verify compression effectiveness and dimension preservation"
    
    # 获取原始图片尺寸
    original_size=$(identify -format "%wx%h" test1.png)
    compressed_size=$(identify -format "%wx%h" optimized1.png)
    
    # 验证压缩后图片尺寸不变
    [[ "$original_size" == "$compressed_size" ]]
    CHECK_RESULT $? 0 0 "Image dimensions changed after compression"
    
    # 验证文件大小确实减少了（zopflipng应该总是压缩或保持原大小）
    original_file_size=$(stat -c%s test1.png)
    compressed_file_size=$(stat -c%s optimized1.png)
    
    LOG_INFO "Original file size: ${original_file_size} bytes"
    LOG_INFO "Compressed file size: ${compressed_file_size} bytes"
    
    # zopflipng应产生更小或相等的文件大小
    [[ $compressed_file_size -le $original_file_size ]]
    CHECK_RESULT $? 0 0 "Compressed file is larger than original"
    
    # 对复杂图片进行压缩测试
    LOG_INFO "Testing compression on gradient image"
    zopflipng gradient.png gradient_compressed.png
    CHECK_RESULT $? 0 0 "Failed to compress gradient image"
    
    gradient_original_size=$(stat -c%s gradient.png)
    gradient_compressed_size=$(stat -c%s gradient_compressed.png)
    
    # 验证复杂图片也能被压缩
    [[ $gradient_compressed_size -le $gradient_original_size ]]
    CHECK_RESULT $? 0 0 "Gradient image compression failed"
    
    LOG_INFO "Gradient original: ${gradient_original_size} bytes"
    LOG_INFO "Gradient compressed: ${gradient_compressed_size} bytes"
    LOG_INFO "Compression ratio: $((100 - (gradient_compressed_size * 100 / gradient_original_size)))%"
    
    LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  # shellcheck disable=SC2119
  DNF_REMOVE
  rm -rf fast.png iter5.png more_compressed.png optimized1.png test1.png gradient.png gradient_compressed.png
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
