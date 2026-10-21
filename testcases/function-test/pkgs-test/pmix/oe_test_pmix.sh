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
# @Author    :   wangxiaorou
# @Contact   :   wangxiaorou@uniontech.com
# @Date      :   2023/12/28
# @License   :   Mulan PSL v2
# @Desc      :   test pmix
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "pmix pmix-devel pmix-tools gcc clang"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  pmix_info --all 
  CHECK_RESULT $? 0 0 "display all information failed"
  pmix_info --config 
  CHECK_RESULT $? 0 0 "display config information failed"
  pmix_info --hostname
  CHECK_RESULT $? 0 0 "display hostname information failed"
  if [ "$(uname -m)" != "riscv64" ]; then
      pmixcc -dumpspecs 
  fi
  CHECK_RESULT $? 0 0 "display dumpspecs information failed"
  pmixcc -dumpmachine 
  CHECK_RESULT $? 0 0 "display dumpmachine information failed"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"


