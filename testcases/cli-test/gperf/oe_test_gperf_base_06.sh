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

  gperf --duplicates ./common/test.gperf >./tmp/test1.hpp
  CHECK_RESULT "$(test -f ./tmp/test1.hpp)"

  gperf -m'ITERATIONS' ./common/test.gperf >./tmp/test2.hpp
  CHECK_RESULT "$(test -f ./tmp/test2.hpp)"

  gperf --multiple-iterations='ITERATIONS' ./common/test.gperf >./tmp/test3.hpp
  CHECK_RESULT "$(test -f ./tmp/test3.hpp)"

  gperf -i'1' ./common/test.gperf >./tmp/test4.hpp
  CHECK_RESULT "$(test -f ./tmp/test4.hpp)"

  gperf --initial-asso='1' ./common/test.gperf >./tmp/test5.hpp
  CHECK_RESULT "$(test -f ./tmp/test5.hpp)"

  gperf -j '10' ./common/test.gperf >./tmp/test6.hpp
  CHECK_RESULT "$(test -f ./tmp/test6.hpp)"

  gperf --jump='10' ./common/test.gperf >./tmp/test7.hpp
  CHECK_RESULT "$(test -f ./tmp/test7.hpp)"

  gperf -n ./common/test.gperf >./tmp/test8.hpp
  CHECK_RESULT "$(test -f ./tmp/test8.hpp)"

  gperf --no-strlen ./common/test.gperf >./tmp/test9.hpp
  CHECK_RESULT "$(test -f ./tmp/test9.hpp)"

  gperf -r ./common/test.gperf >./tmp/test10.hpp
  CHECK_RESULT "$(test -f ./tmp/test10.hpp)"

  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."

  DNF_REMOVE
  rm -rf tmp

  LOG_INFO "Finish restoring the test environment."
}

main $@
