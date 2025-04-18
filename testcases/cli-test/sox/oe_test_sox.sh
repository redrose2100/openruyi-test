#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2023/12/13
# @License   :   Mulan PSL v2
# @Desc      :   test sox
# ############################################
# shellcheck disable=SC1090

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "sox"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  sox common/input.mp3 output.wav
  CHECK_RESULT $? 0 0 "sox failure"
  test -e output.wav
  CHECK_RESULT $? 0 0 "output.wav not exist"
  if ! lspci | grep -i audio; then
    LOG_INFO "No audio device available"
  else
    sox output.wav -d
    CHECK_RESULT $? 0 0 "output.wav play failure"
  fi
  sox output.wav output2.wav trim 10 20
  CHECK_RESULT $? 0 0 "Cropping audio failed"
  test -e output2.wav
  CHECK_RESULT $? 0 0 "output2.wav not exist"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf output*.wav
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
