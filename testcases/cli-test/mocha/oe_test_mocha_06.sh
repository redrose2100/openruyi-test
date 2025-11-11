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
# @Author    :   zhaozhenyang
# @Contact   :   zhaozhenyang@uniontech.com
# @Date      :   2024/03/19
# @License   :   Mulan PSL v2
# @Desc      :   test  mocha
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  VERSION_ID=$(grep "VERSION_ID" /etc/os-release | awk -F '\"' '{print$2}')
  case "$VERSION_ID" in
    20.03|20.09|22.03|22.09|23.03|23.09|24.03|24.09|25.03)
      ;;
    *)
      # 自 25.09 版本起，mocha 已被弃用
      LOG_WARN "mocha has been deprecated in this version"
      exit 255
      ;;
  esac
  DNF_INSTALL mocha
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  mocha -S common/test.js  | grep passing
  CHECK_RESULT $? 0 0 "-S execution failed"
  mocha -mocha --reporter spec  common/test.js | grep passing
  CHECK_RESULT $? 0 0 "--reporter execution failed"
  mocha --ui bdd common/test.js |grep passing
  CHECK_RESULT $? 0 0 "--interfaces execution failed"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"

