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
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2024/08/13
# @License   :   Mulan PSL v2
# @Desc      :   test zipsplit
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  cd /tmp || exit
  echo "sdfassaaasd1223123223424435rrte" > test.txt
  zip test.zip test.txt
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  cd /tmp || exit
  zipsplit -q test.zip
  CHECK_RESULT $? 0 0 "Splitting the test.zip file in quiet mode failed"
  zipsplit -t test.zip
  CHECK_RESULT $? 0 0 "Failed to check file list size"
  zipsplit -i test.zip
  CHECK_RESULT $? 0 0 "Import file from compressed file for execution failed"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf /tmp/test.zip
  rm -rf /tmp/test1.zip
  rm -rf /tmp/zipsplit.idx
  rm -rf /tmp/test.txt
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
