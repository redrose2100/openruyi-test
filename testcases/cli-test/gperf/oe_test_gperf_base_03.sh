source ${OET_PATH}/libs/locallibs/common_lib.sh
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
# @Date      :   2022/11/22
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of mpich command
# ############################################

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL gperf
  mkdir tmp
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."

  gperf -7 ./common/test.gperf 2>&1 | grep 'Command-line: gperf -7'
  CHECK_RESULT $? 0 0 "Check gperf -7 failed."

  gperf --seven-bit ./common/test.gperf 2>&1 | grep 'Command-line: gperf --seven-bit'
  CHECK_RESULT $? 0 0 "Check gperf --seven-bit failed."

  gperf -l ./common/test.gperf 2>&1 | grep 'Command-line: gperf -l'
  CHECK_RESULT $? 0 0 "Check gperf -l failed."

  gperf --compare-lengths ./common/test.gperf 2>&1 | grep 'Command-line: gperf --compare-lengths'
  CHECK_RESULT $? 0 0 "Check gperf --compare-lengths failed."

  gperf -c ./common/test.gperf 2>&1 | grep 'Command-line: gperf -c'
  CHECK_RESULT $? 0 0 "Check gperf -c failed."

  gperf --compare-strncmp ./common/test.gperf 2>&1 | grep 'Command-line: gperf --compare-strncmp'
  CHECK_RESULT $? 0 0 "Check gperf --compare-strncmp failed."

  gperf -C ./common/test.gperf 2>&1 | grep 'Command-line: gperf -C'
  CHECK_RESULT $? 0 0 "Check gperf -C failed."

  gperf --readonly-tables ./common/test.gperf 2>&1 | grep 'Command-line: gperf --readonly-tables'
  CHECK_RESULT $? 0 0 "Check gperf --readonly-tables failed."

  gperf -E ./common/test.gperf 2>&1 | grep 'Command-line: gperf -E'
  CHECK_RESULT $? 0 0 "Check gperf -E failed."

  gperf --enum ./common/test.gperf 2>&1 | grep 'Command-line: gperf --enum'
  CHECK_RESULT $? 0 0 "Check gperf --enum failed."

  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."

  DNF_REMOVE gperf
  rm -rf tmp
  LOG_INFO "Finish restoring the test environment."
}

main $@
