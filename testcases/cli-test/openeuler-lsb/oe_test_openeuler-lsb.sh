#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2025/01/14
# @License   :   Mulan PSL v2
# @Desc      :   test openeuler-lsb
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "openeuler-lsb"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  [[ "$(lsb_release -v)" =~  "LSB Version:" ]]
  CHECK_RESULT $? 0 0 "lsb_release -v failed!"
  [[ "$(lsb_release -i)" =~  "Distributor ID:" ]]
  CHECK_RESULT $? 0 0 "lsb_release -i failed!"
  [[ "$(lsb_release -d)" =~  "Description:" ]]
  CHECK_RESULT $? 0 0 "lsb_release -d failed!"
  [[ "$(lsb_release -r)" =~  "Release:" ]]
  CHECK_RESULT $? 0 0 "lsb_release -r failed!"
  [[ "$(lsb_release -c)" =~  "Codename:" ]]
  CHECK_RESULT $? 0 0 "lsb_release -c failed!"
  lsb_release -s
  CHECK_RESULT $? 0 0 "lsb_release -s failed!"
  lsb_release -a
  CHECK_RESULT $? 0 0 "lsb_release -a failed!"
  lsb_release -h | grep 'Usage'
  CHECK_RESULT $? 0 0 "lsb_release -h failed!"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  # shellcheck disable=SC2119
  DNF_REMOVE
  LOG_INFO "Finish environment cleanup!"
}

main "$@"

