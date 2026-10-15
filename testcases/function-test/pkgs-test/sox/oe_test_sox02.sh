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
# @Date      :   2024/4/1
# @License   :   Mulan PSL v2
# @Desc      :   test sox -n -i -r
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "sox"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  sox common/input.mp3 -n stat
  CHECK_RESULT $? 0 0 "test -n stat option failed"
  sox --i common/input.mp3
  CHECK_RESULT $? 0 0 "test --i option failed"
  
  sox common/input.mp3 output.wav
  test -e  output.wav
  CHECK_RESULT $? 0 0 "output.wav not exist"
  sox output.wav -r 48k -c 1 -b 16 output1.wav
  test -e  output1.wav
  CHECK_RESULT $? 0 0 "output1.wav not exist"
  channel_after=$(soxi output1.wav |grep Channels | awk '{print $3}')
  samplerate_after=$(soxi output1.wav |grep "Sample Rate" | awk '{print $4}')
  Precision_after=$(soxi output1.wav |grep "Precision" | awk '{print $3}')
  CHECK_RESULT "$channel_after" "1" 0 "check channel data not correct"
  CHECK_RESULT "$samplerate_after" "48000" 0 "check samplerate not correct"
  CHECK_RESULT "$Precision_after" "16-bit" 0 "check Precision not correct"
  sox output1.wav output2.wav speed 2
  test -e  output2.wav
  CHECK_RESULT $? 0 0 "output2.wav not exist"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf  output*.wav
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
