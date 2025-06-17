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
# @Author    :   zuohanxu
# @Contact   :   zuohanxu@uniontech.com
# @Date      :   2024/12/13
# @License   :   Mulan PSL v2
# @Desc      :   test zipsplit
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  dd if=/dev/zero of=test_zip.txt bs=1M count=10
  zip test_zip.zip test_zip.txt
  echo "minimal content" > minimal.txt
  zip -q minimal.zip minimal.txt
  echo "This is not a zip file" > not_a_zip.txt
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  zipsplit test_zip.zip
  test -e test_zi1.zip && rm -rf test_zi1.zip
  CHECK_RESULT $? 0 0 "zipsplit execution failure"
  zipsplit -b /tmp test_zip.zip
  test -e /tmp/test_zi1.zip
  CHECK_RESULT $? 0 0 "zipsplit -b execution failure"
  zipsplit -r 500 test_zip.zip
  test -e test_zi1.zip
  CHECK_RESULT $? 0 0 "zipsplit -r execution failure"
  zipsplit -v | grep -i zipsplit
  CHECK_RESULT $? 0 0 "zipsplit version check failed"
  zipsplit not_a_zip.txt 2>&1 | grep -q "not a zip file"
  CHECK_RESULT $? 0 0 "Non-zip file test failed"
  zipsplit minimal.zip
  CHECK_RESULT $? 0 0 "Minimal zip test failed"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf test_zi* /tmp/test_zi1.zip  minimal.txt minimal.zip not_a_zip.txt
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
