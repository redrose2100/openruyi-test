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
# @Author    :   changxuqing
# @Contact   :   changxuqing@uniontech.com
# @Date      :   2024/03/06
# @License   :   Mulan PSL v2
# @Desc      :   test ffmpeg
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "ffmpeg"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  ffmpeg -i common/1.mp4 output.mkv
  CHECK_RESULT $? 0 0 "convert to .mkv type failed"
  test -e output.mkv
  CHECK_RESULT $? 0 0 ".mkv file not exist"

  ffmpeg -i common/1.mp4 output_01.avi
  CHECK_RESULT $? 0 0 "convert to .avi type failed"
  test -e output_01.avi
  CHECK_RESULT $? 0 0 ".avi file not exist"
 
  ffmpeg -i common/1.mp4 -vn output_02.mp3
  CHECK_RESULT $? 0 0 "convert to .mp3 type failed"
  test -e output_02.mp3
  CHECK_RESULT $? 0 0 ".mp3 file not exist"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf output*
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
