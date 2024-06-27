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
# @Date      :   2024/05/24
# @License   :   Mulan PSL v2
# @Desc      :   utshell-test-p
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utshell -c  "mkfifo test1"
  CHECK_RESULT $? 0 0 "test1 fail"
  utshell -c "test -p test1"
  CHECK_RESULT $? 0 0 "ne fail"
  touch 1.txt
  CHECK_RESULT $? 0 0 "1.txt fail"
  utshell -c "test -p 1.txt"
  CHECK_RESULT $? 0 1 "test 1.txt fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf 1.txt test1
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"