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
# @Author    :   changxuqing
# @Contact   :   changxuqing@uniontech.com
# @Date      :   2023/08/16
# @License   :   Mulan PSL v2
# @Desc      :   test bacula-client
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "bacula-client lsof"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  bacula-fd -c /etc/bacula/bacula-fd.conf
  CHECK_RESULT $? 0 0 "Executed successfully"
  SLEEP_WAIT 5
  lsof -i:9102 | grep "bacula-fd"
  CHECK_RESULT $? 0 0 "process exit"
  test -e /var/run/bacula-fd.9102.pid
  CHECK_RESULT $? 0 0 "pid not exist"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  pkill bacula-fd
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
