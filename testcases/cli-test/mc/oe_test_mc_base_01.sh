# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of mc command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL mc
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."

  mc -h 2>&1 | grep '--help'
  CHECK_RESULT $? 0 0 "Check mc -h failed"

  mc --help 2>&1 | grep '--help'
  CHECK_RESULT $? 0 0 "Check mc --help failed"

  mc -V 2>&1 | grep 'GNU Midnight Commander' >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mc -V  failed"

  mc --version 2>&1 | grep 'GNU Midnight Commander' >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mc --version  failed"

  mc -f 2>&1 | grep '/etc/mc/ (/usr/share/mc/)' >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mc -f  failed"

  mc --datadir 2>&1 | grep '/etc/mc/ (/usr/share/mc/)' >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mc --datadir  failed"

  mc -F 2>&1 | grep 'Home路径' >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mc -F  failed"

  mc --datadir-info 2>&1 | grep 'Home' >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mc --datadir-info  failed"

  mc --configure-options 2>&1 | grep "'--build=" >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mc --configure-options  failed"

  mc -P mc.txt >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mc -P  failed"

  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."

  DNF_REMOVE

  LOG_INFO "Finish restoring the test environment."
}

main $@
