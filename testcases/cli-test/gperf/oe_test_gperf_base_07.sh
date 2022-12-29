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

  gperf --random ./common/test.gperf 2>&1 | grep 'Command-line: gperf --random'
  CHECK_RESULT $? 0 0 "Check gperf --random failed."

  gperf -s'2' ./common/test.gperf 2>&1 | grep 'Command-line: gperf -s'
  CHECK_RESULT $? 0 0 "Check gperf -s failed."

  gperf --size-multiple='2' ./common/test.gperf 2>&1 | grep 'Command-line: gperf --size-multiple'
  CHECK_RESULT $? 0 0 "Check gperf --size-multiple failed."

  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."

  DNF_REMOVE
  rm -rf tmp
  LOG_INFO "Finish restoring the test environment."
}

main $@
