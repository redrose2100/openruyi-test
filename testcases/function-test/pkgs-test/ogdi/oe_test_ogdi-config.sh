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
# @Date      :   2024/03/22
# @License   :   Mulan PSL v2
# @Desc      :   test  oathtool
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL ogdi-devel
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  ogdi-config -h |grep print
  CHECK_RESULT $? 0 0 "Failed to obtain help command"
  ogdi-config --version | grep "$(rpm -q ogdi-devel | awk -F '-' '{print $3}')"
  CHECK_RESULT $? 0 0 "Error in obtaining version command"
  ogdi-config --prefix |grep usr 
  CHECK_RESULT $? 0 0 "Error printing prefix path for libogdi"
  ogdi-config --libdir |grep lib64
  CHECK_RESULT $? 0 0 "Error printing directory path containing library files"
  ogdi-config --cflags |grep tirpc 
  CHECK_RESULT $? 0 0 "Error printing preprocessor flags, I_opts, and compiler options"
  ogdi-config --I_opts |grep ogdi
  CHECK_RESULT $? 0 0 "Print "- I" with option error" 
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
