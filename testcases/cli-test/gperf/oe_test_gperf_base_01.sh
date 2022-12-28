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

  gperf --help 2>&1 | grep "GNU 'gperf' generates"
  CHECK_RESULT $? 0 0 "Check '--help  failed"

  gperf -h 2>&1 | grep "GNU 'gperf' generates"
  CHECK_RESULT $? 0 0 "Check gperf -h failed."

  gperf --version 2>&1 | grep -E "GNU gperf.[0-9]{1,}"
  CHECK_RESULT $? 0 0 "Check gperf --version failed."

  gperf -v 2>&1 | grep "GNU gperf "
  CHECK_RESULT $? 0 0 "Check gperf -v failed."

  gperf -d -e 2>&1 | grep "Starting program gperf"
  CHECK_RESULT $? 0 0 "Check gperf -d failed."

  gperf --debug -e 2>&1 | grep "Starting program gperf"
  CHECK_RESULT $? 0 0 "Check gperf -d failed."

  gperf -d -e ',' ./common/test.gperf >./tmp/test1.hpp
  CHECK_RESULT "$(test -f ./tmp/test1.hpp)"
  rm -rf ./tmp/test1.hpp

  gperf --delimiters=',' common/test.gperf >./tmp/test2.hpp
  CHECK_RESULT "$(test -f ./tmp/test2.hpp)"
  rm -rf ./tmp/test2.hpp

  gperf -t ./common/test.gperf >./tmp/test3.hpp
  CHECK_RESULT "$(test -f ./tmp/test3.hpp)"
  rm -rf ./tmp/test3.hpp

  gperf --struct-type ./common/test.gperf >./tmp/test4.h
  CHECK_RESULT "$(test -f ./tmp/test4.hpp)"
  rm -rf ./tmp/test4.h

  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."

  DNF_REMOVE
  rm -rf tmp
  LOG_INFO "Finish restoring the test environment."
}

main $@

