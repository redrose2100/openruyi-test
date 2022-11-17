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

  mc --printwd=mc.txt >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mc --printwd  failed"

  mc -U >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mc -U  failed"

  mc --subshell >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mc --subshell  failed"

  mc -u >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mc -u  failed"

  mc -l ./mc.txt >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mc -l  failed"

  mc --ftplog=txt.mc >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mc --ftplog  failed"

  mc -v mc.txt >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mc -v  failed"

  mc --view=mc.txt >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mc --view  failed"

  mc -e mc.txt >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mc -e  failed"

  mc --edit=mc.txt >/dev/nul 2>&1 &
  CHECK_RESULT $? 0 0 "Check mc --edit  failed"

  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."

  DNF_REMOVE

  LOG_INFO "Finish restoring the test environment."
}

main $@
