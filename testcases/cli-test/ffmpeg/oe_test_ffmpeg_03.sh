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
# @Date      :   2025/01/13
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
  ffmpeg -i common/1.mp4 -s 1280x720 output_01.mp4
  CHECK_RESULT $? 0 0 "convert with -s option failed"
  test -e output_01.mp4
  CHECK_RESULT $? 0 0 "output_01.mp4 file not exist"

  ffmpeg -i common/1.mp4 -filter:a "volume=1.5" output_02.mp4
  CHECK_RESULT $? 0 0 "change volume failed"
  test -e output_02.mp4
  CHECK_RESULT $? 0 0 "output_02.mp4 file not exist"
 
  ffmpeg -i common/1.mp4 -filter:a "atempo=2.0" output_03.mp4
  CHECK_RESULT $? 0 0 "change atempo failed"
  test -e output_03.mp4
  CHECK_RESULT $? 0 0 "output_03.mp3 file not exist"

  ffmpeg -i common/1.mp4 -vframes 1 output_04.png
  CHECK_RESULT $? 0 0 "convert with -vframes option failed"
  test -e output_04.png
  CHECK_RESULT $? 0 0 "output_04.png file not exist"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf output*
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
