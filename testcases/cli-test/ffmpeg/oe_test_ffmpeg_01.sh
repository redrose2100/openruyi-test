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
# @Contact   :   gaoshuaishaui@uniontech.com
# @Date      :   2024/02/22
# @License   :   Mulan PSL v2
# @Desc      :   test  ffmpeg
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL ffmpeg
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  ffprobe common/test.mpg
  CHECK_RESULT $? 0 0 "Failed to obtain information from test.mpg file"
  ffmpeg -i common/test.mpg test.yuv
  CHECK_RESULT $? 0 0 "Ffmpeg decoding MPEG-2 video file to YUV format error"
  ffplay test.yuv 
  CHECK_RESULT $? 0 0 "Failed to retrieve information from test.yuv file"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf test.yuv
  LOG_INFO "Finish environment cleanup!"
}

main "$@"

