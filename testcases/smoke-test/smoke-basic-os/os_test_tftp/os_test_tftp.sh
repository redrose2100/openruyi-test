#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   weixuan
# @Contact   :   weixuan@uniontech.com
# @Date      :   2022-11-04
# @License   :   Mulan PSL v2
# @Desc      :   Command test  sos
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    LOG_INFO "No pkgs need to install."

    LOG_INFO "End to prepare the test environment."
}


function run_test() {
  LOG_INFO "run_test"

  systemctl start tftp.service
  CHECK_RESULT $? 0

  start=$(systemctl status tftp.service | grep Active |awk '{print $3}')
  CHECK_RESULT $start "(running)"

  systemctl restart tftp.service
  CHECK_RESULT $? 0

  restart=$(systemctl status tftp.service | grep Active |awk '{print $3}')
  CHECK_RESULT $start "(running)"

  systemctl stop tftp.service
  CHECK_RESULT $? 0

  restart=$(systemctl status tftp.service | grep Active |awk '{print $3}')
  CHECK_RESULT $restart "(dead)"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    LOG_INFO "Nothing to do."

    LOG_INFO "End to restore the test environment."
}

main "$@"
