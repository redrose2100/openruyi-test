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
# @Date      :   2024/04/01
# @License   :   Mulan PSL v2
# @Desc      :   test nss-softokn-devel 
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL nss-softokn-devel
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  nss-softokn-config --libs |grep lib64
  CHECK_RESULT $? 0 0 "Error retrieving library file"
  nss-softokn-config --version | grep "$(rpm -q nss-softokn-devel | awk -F '-' '{print $4}')"
  CHECK_RESULT $? 0 0 "Error in obtaining version command"
  nss-softokn-config --cflags |grep nss 
  CHECK_RESULT $? 0 0 "Error in obtaining flags"
  nss-softokn-config --libdir |grep usr 
  CHECK_RESULT $? 0 0 "Error getting library file directory"
  nss-softokn-config --includedir |grep include
  CHECK_RESULT $? 0 0 "Error in obtaining display header file"
  nss-softokn-config --exec-prefix |grep usr
  CHECK_RESULT $? 0 0 "Error getting prefix for displaying executable file installation directory" 
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
