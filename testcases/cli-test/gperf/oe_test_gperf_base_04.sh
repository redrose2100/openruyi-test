source ${OET_PATH}/libs/locallibs/common_lib.sh
# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."

  mkdir tep

  gperf -I ./common/test.gperf >./tmp/test.hpp
  CHECK_RESULT "$(ls ./tmp | grep -cE "test.hpp")" 1
  rm -rf ./tmp/test.hpp

  gperf --includes ./common/test.gperf >./tmp/test.hpp
  CHECK_RESULT "$(ls ./tmp | grep -cE "test.hpp")" 1
  rm -rf ./tmp/test.hpp

  gperf -G ./common/test.gperf >./tmp/test.hpp
  CHECK_RESULT "$(ls ./tmp | grep -cE "test.hpp")" 1
  rm -rf ./tmp/test.hpp

  gperf --global-table ./common/test.gperf >./tmp/test.hpp
  CHECK_RESULT "$(ls ./tmp | grep -cE "test.hpp")" 1
  rm -rf ./tmp/test.hpp

  gperf -P ./common/test.gperf >./tmp/test.hpp
  CHECK_RESULT "$(ls ./tmp | grep -cE "test.hpp")" 1
  rm -rf ./tmp/test.hpp

  gperf --pic ./common/test.gperf >./tmp/test.hpp
  CHECK_RESULT "$(ls ./tmp | grep -cE "test.hpp")" 1
  rm -rf ./tmp/test.hpp

  gperf -Q 'NAME' ./common/test.gperf >./tmp/test.hpp
  CHECK_RESULT "$(ls ./tmp | grep -cE "test.hpp")" 1
  rm -rf ./tmp/test.hpp

  gperf --string-pool-name='NAME' ./common/test.gperf >./tmp/test.hpp
  CHECK_RESULT "$(ls ./tmp | grep -cE "test.hpp")" 1
  rm -rf ./tmp/test.hpp

  gperf --null-strings ./common/test.gperf >./tmp/test.hpp
  CHECK_RESULT "$(ls ./tmp | grep -cE "test.hpp")" 1
  rm -rf ./tmp/test.hpp

  gperf --constants-prefix='PREFIX' ./common/test.gperf >./tmp/test.hpp
  CHECK_RESULT "$(ls ./tmp | grep -cE "test.hpp")" 1
  rm -rf ./tmp/test.hpp

  rm -rf tmp

  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."

  DNF_REMOVE

  LOG_INFO "Finish restoring the test environment."
}

main $@
