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
# @Author    :   jingxiaohui
# @Contact   :   jingxiaohui@uniontech.com
# @Date      :   2024.6.21
# @License   :   Mulan PSL v2
# @Desc      :   enable using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utshell -c "enable --help"|grep -i enable
  CHECK_RESULT $? 0 0 " enable --help fail"
  utshell -c "enable -a"|grep -i enable
  CHECK_RESULT $? 0 0 "enable -a fail"
  utshell -c "enable -n"
  CHECK_RESULT $? 0 0 " enable -n fail"
  utshell -c "enable -n wait;enable -n |grep wait"
  CHECK_RESULT $? 0 0 "enable -n wait;enable -n |grep wait fail"
  utshell -c "enable -a wait;enable -n | grep wait" 
  CHECK_RESULT $? 1 0 "enable -a wait;enable -n | grep wait fail"
  utshell -c "enable -s"|grep -i enable
  CHECK_RESULT $? 0 0 "enable -s fail"
  utshell -c "enable -p" 
  CHECK_RESULT $? 0 0 "enable -p fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"