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
# @Author    :   wangxiaorou
# @Contact   :   wangxiaorou@uniontech.com
# @Date      :   2024/07/02
# @License   :   Mulan PSL v2
# @Desc      :   test createrepo_c algorithm
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "createrepo_c"
  test -d DIR-algorithm && rm -rf ./DIR-algorithm
  mkdir DIR-algorithm
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  createrepo_c DIR-algorithm
  CHECK_RESULT $? 0 0 "createrepo fail"
  CHECK_RESULT "$(grep -r -i "checksum type=" DIR-algorithm |awk -F '"' '{print $2}' |uniq)" "sha256" 0 "default algorithm fail"

  createrepo_c -s sha512 DIR-algorithm
  CHECK_RESULT $? 0 0 "createrepo fail"
  CHECK_RESULT "$(grep -r -i "checksum type=" DIR-algorithm |awk -F '"' '{print $2}' |uniq)" "sha512" 0 "chage algorithm fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  test -d DIR-algorithm && rm -rf ./DIR-algorithm
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"


