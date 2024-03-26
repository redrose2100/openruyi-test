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
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2023/07/13
# @License   :   Mulan PSL v2
# @Desc      :   sendmail basic function
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start to prepare the test environment."
  DNF_INSTALL "sendmail telnet lsof"
  mkdir /tmp/test
  LOG_INFO "Finish preparing the test environment."
}

function run_test() {
  LOG_INFO "Start to run test."
  systemctl restart sendmail
  CHECK_RESULT $? 0 0 "Service startup failure"
  lsof -i:25| grep sendmail
  CHECK_RESULT $? 0 0 "Default port error"
  bash common/fun001.sh
  grep 'This is sendmail' /tmp/test/test.txt
  CHECK_RESULT $? 0 0 "Test failure"
  grep 'End of HELP info' /tmp/test/test.txt
  CHECK_RESULT $? 0 0 "Test failure"
  systemctl stop sendmail
  CHECK_RESULT $? 0 0 "Service stop failure"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  rm -rf /tmp/test
  DNF_REMOVE "$@"
  LOG_INFO "Finish restoring the test environment."
}

main "$@"
