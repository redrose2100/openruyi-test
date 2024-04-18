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
# @Author    :   chenyua
# @Contact   :   chenyua@uniontech.com 
# @Date      :   2024/03/28
# @License   :   Mulan PSL v2
# @Desc      :   test nodeunit 
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL nodeunit
  echo -e "exports.testSample = function(test){
  test.expect(1);
  test.ok(true, \"This assertion should pass\");
  test.done();
};" > test.js
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  nodeunit -t testMyFunction test.js | grep OK 
  CHECK_RESULT $? 0 0 "Running nodeunit  to execute test failed"
  nodeunit test.js  --config |grep test
  CHECK_RESULT $? 0 0 "Running nodeunit  to execute test failed"
  nodeunit test.js  --reporter |grep test
  CHECK_RESULT $? 0 0 "NodeUnit List available built-in report generators with errors"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf test.js
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
