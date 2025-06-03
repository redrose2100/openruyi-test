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
# @Desc      :   test augparse
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL augeas
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  augparse -t /usr/share/augeas/lenses/dist/xorg.aug |grep Module 
  CHECK_RESULT $? 0 0 "Augparse tracking output error"
  augparse --notypecheck /usr/share/augeas/lenses/dist/xorg.aug
  CHECK_RESULT $? 0 0 "Type check error for disabling lens"
  augparse /usr/share/augeas/lenses/dist/rx.aug 
  CHECK_RESULT $? 0 0 "Augparse execution failed"
  augparse /usr/share/augeas/lenses/dist/xorg.aug /usr/share/augeas/lenses/dist/rx.aug
  CHECK_RESULT $? 0 0 "Augparse failed to handle multiple input files"  
  augparse /tmp/invalid_lens.aug 2>&1 | grep -q "error"
  CHECK_RESULT $? 0 0 "Augparse should report error for invalid lens file"  
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -f /tmp/invalid_lens.aug
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
