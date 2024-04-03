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
# @Author    :   fuyahong
# @Contact   :   fuyahong@uniontech.com
# @Date      :   2024/1/16
# @License   :   Mulan PSL v2
# @Desc      :   test sox
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "sox"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  soxi common/input.mp3
  sox -v 0.5 common/input.mp3 output_v0.5.wav
  test -e  output_v0.5.wav
  CHECK_RESULT $? 0 0 "output_v0.5.wav not exist"
  soxi output_v0.5.wav |grep "Sample Encoding" | awk -F ":" '{print $2}' |grep "Signed Integer"
  CHECK_RESULT $? 0 0 "check encoding type not correct"
  
  sox common/input.mp3 -c 1 output_c1.wav
  test -e  output_c1.wav
  CHECK_RESULT $? 0 0 "output_c1.wav not exist"
  channel_after=$(soxi output_c1.wav |grep "Channels" | awk -F ":" '{print $2}')
  CHECK_RESULT "$channel_after" " 1" 0 "check channel data not correct"

  sox common/input.mp3 output_tirm1.wav trim 0 10
  sox common/input.mp3 output_tirm2.wav trim 10 20
  sox -m -v0.5 output_tirm1.wav -v2 output_tirm2.wav output_full.wav
  test -e  output_full.wav
  CHECK_RESULT $? 0 0 "output_full.wav not exist"

  sox common/input.mp3 output_left.wav remix 1
  sox common/input.mp3 output_right.wav remix 2
  test -e  output_left.wav
  CHECK_RESULT $? 0 0 "output_left.wav not exist"
  test -e  output_right.wav
  CHECK_RESULT $? 0 0 "output_right.wav not exist"
  channel_left=$(soxi output_left.wav |grep "Channels" | awk -F ":" '{print $2}')
  CHECK_RESULT "$channel_left" " 1" 0 "check left_wav channel data not correct"
  channel_right=$(soxi output_right.wav |grep "Channels" | awk -F ":" '{print $2}')
  CHECK_RESULT "$channel_right" " 1" 0 "check right_wav channel data not correct"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf  output*.wav
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
