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
# @Date      :   2025/05/21
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
  opj2_decompress -i common/test.jp2 -o test.tif
  CHECK_RESULT $? 0 0 "Failed to compress test.jp2 to test.tif"
  opj2_decompress -i common/test.jp2 -o test.tif -d 5
  CHECK_RESULT $? 0 0 "-D 5 specifies a decomposition level quantity of 5, failed"
  opj2_decompress -i common/test.jp2 -o test.tif -r 0.5
  CHECK_RESULT $? 0 0 "Compression bit rate set to 0.5 bits per pixel failed"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf test.tif
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
