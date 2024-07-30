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
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2024/06/27
# @License   :   Mulan PSL v2
# @Desc      :   test openjpeg2-tools
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL openjpeg2-tools
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  opj2_compress -i common/test.tif -o test.j2c
  CHECK_RESULT $? 0 0 "Failed to compress test.tif to JPEG 2000 format and save output as test.j2c"
  opj2_compress -i common/test.tif -o test.j2c -q 50
  CHECK_RESULT $? 0 0 "Compressing image files and setting compression quality to 50 failed"
  opj2_compress -i common/test.tif -o test.j2c -F 1024,768,3,8,u@1x1:2x2:4x4
  CHECK_RESULT $? 0 0 "Compress image file and set width and height, with 3 color components and 3 color components. Multi resolution encoding failed"
  opj2_compress -i common/test.tif -o test.j2c -TargetBitDepth 8
  CHECK_RESULT $? 0 0 "Failed to input the number of bits to be retained for each component in the image"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf test.j2c
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
