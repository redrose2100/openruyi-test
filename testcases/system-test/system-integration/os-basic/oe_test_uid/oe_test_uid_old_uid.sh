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
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023/07.27
# @License   :   Mulan PSL v2
# @Desc      :   old uid function test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
  LOG_INFO "Start to prepare the test environment."
  useradd -u 1009 test1
  LOG_INFO "Finish preparing the test environment."
}

function run_test() {
  LOG_INFO "Start to run test."
  useradd -u 1009 test2 >uid.log 2>&1
  grep -E "not unique|并不唯一" uid.log
  CHECK_RESULT $? 0 0 "Created successfully"
  userdel -rf test1
  useradd -u 1009 test2
  CHECK_RESULT $? 0 0 "Creation failed, uid is unique"
  useradd -u 1010 test1
  usermod -u 1010 test2 >uid.log 2>&1
  grep -E "already exists|已经存在" uid.log
  CHECK_RESULT $? 0 0 "Modification successfully"
  userdel -rf test1
  usermod -u 1010 test2
  CHECK_RESULT $? 0 0 "Modification failed, uid is unique"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  userdel -rf test1
  userdel -rf test2
  rm -rf uid.log
  LOG_INFO "Finish restoring the test environment."
}

main "$@"
