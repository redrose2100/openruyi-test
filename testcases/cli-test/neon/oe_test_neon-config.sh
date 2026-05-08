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
# @Date      :   2024/05/17
# @License   :   Mulan PSL v2
# @Desc      :   test neon-config 
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "neon neon-devel" 
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  neon-config --help |grep print 
  CHECK_RESULT $? 0 0 "Error getting help"
  neon-config --libs |grep lneon
  CHECK_RESULT $? 0 0 "Error in obtaining library link information"
  neon-config --cflags |grep neon  
  CHECK_RESULT $? 0 0 "Error getting preprocessor and compiler flags"
  neon_version=$(rpm -qa neon-devel | awk -F- '{print $3}')
  neon-config --version | grep "${neon_version}"
  CHECK_RESULT $? 0 0 "Error in obtaining neon config version"
  neon-config --prefix | grep usr
  CHECK_RESULT $? 0 0 "Error in obtaining neon config prefix"
  neon-config --la-file | grep libneon
  CHECK_RESULT $? 0 0 "Error in obtaining neon config la-file"  
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"

