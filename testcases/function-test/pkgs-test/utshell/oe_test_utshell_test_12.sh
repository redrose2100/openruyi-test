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
# @Author    :   mataotao
# @Contact   :   mataotao@uniontech.com
# @Date      :   2025/03/24
# @License   :   Mulan PSL v2
# @Desc      :   utshell-test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utshell -c  "test 'test@#123__' = 'test@#123__'"
  res=$(utshell -c "echo $?")
  CHECK_RESULT "$res" 0 0 "test -x test.txt fail"
  utshell -c  "test 'test@#123__' != 'test@#123__'"
  res1=$(utshell -c "echo $?")
  CHECK_RESULT "$res1" 1 0 "test -x test1.txt fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf test.txt
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"