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
# @Date      :   2024/08/01
# @License   :   Mulan PSL v2
# @Desc      :   utshell-test-ef
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utshell -c  "touch 1.txt"
  CHECK_RESULT $? 0 0 "1.txt not exist"
  utshell -c  "touch test"
  CHECK_RESULT $? 0 0 "test not exist"
  utshell -c  "ln test test11"
  CHECK_RESULT $? 0 0 "ln fail"
  utshell -c  "test test11 -ef test"
  CHECK_RESULT $? 0 0 "ef fail"
  utshell -c  "test test11 -ef 1.txt"
  CHECK_RESULT $? 0 1 "ef success"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf test test11
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"