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
# @Date      :   2024/03/19
# @License   :   Mulan PSL v2
# @Desc      :   test  oathtool
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL oathtool
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  oathtool -h |grep digits
  CHECK_RESULT $? 0 0 "Failed to obtain help command"
  oathtool -V |grep "$(rpm -q oathtool | awk -F '-' '{print $2}')"
  CHECK_RESULT $? 0 0 "Error in obtaining version command"
  oathtool --totp -b JBSWY3DPEHPK3PXP 
  CHECK_RESULT $? 0 0 "Generate a one-time verification code error based on time"
  oathtool --hotp -c 5 -b JBSWY3DPEHPK3PXP
  CHECK_RESULT $? 0 0 "Generate one-time verification code error based on events"
  oathtool --totp -s 60 -b JBSWY3DPEHPK3PXP
  CHECK_RESULT $? 0 0 "Generate specified time step to generate TOTP error message" 
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"

