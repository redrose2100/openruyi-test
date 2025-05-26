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
# @Date      :   2023/05/30
# @License   :   Mulan PSL v2
# @Desc      :   logstash install test
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start to prepare the test environment."
  if [ "${NODE1_FRAME}" == "riscv64" ]; then
    LOG_WARN "Testing cannot be performed if NODE1_FRAME is riscv64"
    exit 255
  fi
  DNF_INSTALL "java-1.8.0-openjdk expect wget unzip"
  mkdir /tmp/test
  wget -P /tmp/test https://gitee.com/sunqingwei811/package/repository/archive/master.zip
  LOG_INFO "Finish preparing the test environment."
}

function run_test() {
  LOG_INFO "Start to run test."
  unzip /tmp/test/master.zip -d /tmp/test
  CHECK_RESULT $? 0 0 "Unzip file failed"
  cp ./common/test.sh /tmp/test/package-master/logstash-6.6.1/bin
  cd /tmp/test/package-master/logstash-6.6.1/bin || return
  chmod 777 logstash
  bash test.sh
  grep '\"message\"' test.log | grep '\"hello world\"'
  CHECK_RESULT $? 0 0 "Test failed"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  rm -rf /tmp/test
  DNF_REMOVE "$@"
  LOG_INFO "Finish restoring the test environment."
}

main "$@"