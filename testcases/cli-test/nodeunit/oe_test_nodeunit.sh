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
# @Date      :   2024/03/13
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
  nodeunit test.js  
  CHECK_RESULT $? 0 0 "Running nodeunit  to execute test failed"
  nodeunit test.js --list-reporters |grep ormat
  CHECK_RESULT $? 0 0 "NodeUnit lists available built-in report generator errors"
  nodeunit -v |grep 9
  CHECK_RESULT $? 0 0 "NodeUnit listing version information error"
  nodeunit -h |grep the
  CHECK_RESULT $? 0 0 "NodeUnit listing help information error"
  nodeunit test.js -t  |grep OK 
  CHECK_RESULT $? 0 0 "NodeUnit listing -t error"
  nodeunit test.js -f  |grep OK 
  CHECK_RESULT $? 0 0 "NodeUnit listing -t failed"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf test.js
  LOG_INFO "Finish environment cleanup!"
}

main "$@"

