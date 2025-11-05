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
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2025/11/05
# @License   :   Mulan PSL v2
# @Desc      :   test espeak-ng
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "espeak-ng"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  espeak-ng -v en -s 120 -p 50 -w voice_test.wav "Testing voice parameters"
  CHECK_RESULT $? 0 0 "Failed to use voice parameters"
  test -e voice_test.wav
  CHECK_RESULT $? 0 0 "Voice parameters test file not created"
  file_size1=$(wc -c < voice_test.wav)
  test "$file_size1" -gt 1000
  CHECK_RESULT $? 0 0 "Voice parameters test file too small"
  rm -f voice_test.wav

  espeak-ng -w amplitude_test.wav -a 200 "Testing amplitude"
  CHECK_RESULT $? 0 0 "Failed to set amplitude"
  test -e amplitude_test.wav
  CHECK_RESULT $? 0 0 "Amplitude test file not created"
  file_size2=$(wc -c < amplitude_test.wav)
  test "$file_size2" -gt 1000
  CHECK_RESULT $? 0 0 "Amplitude test file too small"
  rm -f amplitude_test.wav

  espeak-ng -v en-us -w us_voice.wav "American English test"
  CHECK_RESULT $? 0 0 "Failed to use US English voice"
  test -e us_voice.wav
  CHECK_RESULT $? 0 0 "US English voice file not created"
  rm -f us_voice.wav

  espeak-ng --voices | head -5 | grep -q "en"
  CHECK_RESULT $? 0 0 "Failed to list available voices"
  espeak-ng --version | grep -q "eSpeak"
  CHECK_RESULT $? 0 0 "Failed to get version information"

  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf voice_test.wav amplitude_test.wav us_voice.wav
  LOG_INFO "Finish environment cleanup!"
}

main "$@"