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
# @Date      :   2025/01/14
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

  ffmpeg -i common/1.mp4 -ss 00:00:00 -t 00:00:10 -c copy output_01.mp4
  ffmpeg -i common/1.mp4 -ss 00:00:15 -t 00:00:20 -c copy output_02.mp4
  test -e output_01.mp4
  CHECK_RESULT $? 0 0 "output_01.mp4 file not exist"
  test -e output_02.mp4
  CHECK_RESULT $? 0 0 "output_02.mp4 file not exist"

  cat >./filelist.txt<<EOF
file 'output_01.mp4'
file 'output_02.mp4'
EOF
  ffmpeg -f concat -safe 0 -i filelist.txt -c copy output_03.mp4
  CHECK_RESULT $? 0 0 "concat files failed"
  test -e output_03.mp4
  CHECK_RESULT $? 0 0 "output_03.mp3 file not exist"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf output* filelist.txt
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
