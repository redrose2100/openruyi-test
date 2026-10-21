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
# @Date      :   2023/04/10
# @License   :   Mulan PSL v2
# @Desc      :   test flac
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "flac"
  rm -rf ./example.*
  cp ./common/test.wav ./example.wav
  file ./example.wav
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  flac --version
  CHECK_RESULT $? 0 0 "--version option failed"
  flac example.wav
  CHECK_RESULT $? 0 0 "wav file convert to falc failed"
  test -e example.flac
  CHECK_RESULT $? 0 0 "example.flac not exist"
  flac -t example.flac
  CHECK_RESULT $? 0 0 "flac -t exec failed"

  flac -d cron.flac
  test -e cron.wav
  CHECK_RESULT $? 0 0 "wav not exist"
  flac -a cron.flac
  test -e cron.ana
  CHECK_RESULT $? 0 0 "ana not exist"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf cron.wav cron.ana example.*
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
