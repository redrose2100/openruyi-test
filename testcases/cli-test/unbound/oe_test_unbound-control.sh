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
# @Author    :   wangxiaorou
# @Contact   :   wangxiaorou@uniontech.com
# @Date      :   2023/12/14
# @License   :   Mulan PSL v2
# @Desc      :   test unbound-control
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "unbound unbound-devel"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  systemctl start  unbound.service
  CHECK_RESULT "$(systemctl is-active unbound.service)" "active" 0 "unbound.service status failed"

  unbound-checkconf /etc/unbound/unbound.conf 
  CHECK_RESULT $? 0 0 "checkconf failed"
  unbound-control-setup
  CHECK_RESULT $? 0 0 "set up the keys and certificates failed"

  unbound-control stats_noreset
  CHECK_RESULT $? 0 0 "print statistics without resetting them failed"
  unbound-control dump_cache
  CHECK_RESULT $? 0 0 "dump cache to stdout failed"
  unbound-control reload
  CHECK_RESULT $? 0 0 "flush cache and reload configuration failed"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}
