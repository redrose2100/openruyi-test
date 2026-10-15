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
# @Author    :   liangjiayu01
# @Contact   :   liangjiayu@uniontech.com
# @Date      :   2024.07.12
# @License   :   Mulan PSL v2
# @Desc      :   utshell ps_002 test
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utshell -c "ps -u | grep root"
  CHECK_RESULT $? 0 0 "ps -u fail"
  utshell -c "ps -x | grep kworker"
  CHECK_RESULT $? 0 0 "test ps -x fail"
  utshell -c "ps -f | grep pts"
  CHECK_RESULT $? 0 0 "test ps -f fail"
  utshell -c "ps -e | grep highpri"
  CHECK_RESULT $? 0 0 "test ps -e fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup."
}

main "$@"

