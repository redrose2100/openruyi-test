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
# @Desc      :   eval using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utshell -c "shopt --help"|grep -i shopt 
  CHECK_RESULT $? 0 0 "shopt --help fail"
  utshell -c "shopt -p"|grep -e shopt
  CHECK_RESULT $? 0 0 "shopt -p fail"
  utshell -c "shopt"|grep -i off
  CHECK_RESULT $? 0 0 "shopt fail"
  utshell -c "shopt -s nullglob;shopt|grep nullglob"|grep on
  CHECK_RESULT $? 0 0 "shopt fail"
  utshell -c "shopt -u nullglob;shopt| grep nullglob"|grep off
  CHECK_RESULT $? 0 0 "shopt fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"