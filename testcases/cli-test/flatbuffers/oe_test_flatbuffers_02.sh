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
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2023/11/17
# @License   :   Mulan PSL v2
# @Desc      :   test  flatbuffers
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "flatbuffers flatbuffers-compiler"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  flatc --java common/monster.fbs
  test -f com/zeyuan/learning/Color.java
  CHECK_RESULT $? 0 0 "com/zeyuan/learning/Color.java failure"
  flatc --php common/monster.fbs
  test -f com/zeyuan/learning/Vec3.php
  CHECK_RESULT $? 0 0 "com/zeyuan/learning/Vec3.php failure"
  flatc --lua common/monster.fbs
  test -f com/zeyuan/learning/Color.lua
  CHECK_RESULT $? 0 0 "com/zeyuan/learning/Color.lua failure"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf com
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
