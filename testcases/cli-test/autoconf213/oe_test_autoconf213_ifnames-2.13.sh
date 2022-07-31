#!/usr/bin/bash

# Copyright (c) 2020. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   LiuZiyi
# @Contact   :   lavandejoey@outlook.com
# @Date      :   2022/4/29
# @Desc      :   Test "ifnames-2.13 [-m dir] [--macrodir=dir] [FILE] " command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start to prepare the test environment."
  DNF_INSTALL autoconf213

  # test_macro
  cp -r /usr/share/autoconf-2.13 "$OET_PATH"/testcases/cli-test/autoconf213/common/test-macro
  LOG_INFO "Test environment is ready."
}

function run_test() {
  LOG_INFO "Start to run test."
  cd "$OET_PATH"/testcases/cli-test/autoconf213/common/ || exit
  ifnames-2.13 ./ifname_test* 2>&1 | grep "DEF_VAR_1 .*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 ifnames-test-2.c run failed"
  ifnames-2.13 ./ifname_test* 2>&1 | grep "DEF_VAR_1 .*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 ifnames-test-1.c run failed"
  ifnames-2.13 ./ifname_test* 2>&1 | grep "IFNDEF_VAR.*1\.c.*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 multi source file run failed"
  ifnames-2.13 ./ifname_test* 2>&1 | grep "ifnames-test-3\.c"
  CHECK_RESULT $? 1 0 "Error: ifnames-2.13 ifnames-test-3.c(ineligible) source file run failed"

  # [-m dir] [--macrodir=dir]
  cd "$OET_PATH"/testcases/cli-test/autoconf213/common/ || exit
  ifnames-2.13 -m ./test-macro ./ifname_test* 2>&1 | grep "DEF_VAR_1 .*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 ifnames-test-2.c run failed"
  ifnames-2.13 -m ./test-macro ./ifname_test* 2>&1 | grep "DEF_VAR_1 .*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 ifnames-test-1.c run failed"
  ifnames-2.13 -m ./test-macro ./ifname_test* 2>&1 | grep "IFNDEF_VAR.*1\.c.*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 multi source file run failed"
  ifnames-2.13 -m ./test-macro ./ifname_test* 2>&1 | grep "ifnames-test-3\.c"
  CHECK_RESULT $? 1 0 "Error: ifnames-2.13 ifnames-test-3.c(ineligible) source file run failed"

  cd "$OET_PATH"/testcases/cli-test/autoconf213/common/ || exit
  ifnames-2.13 --macrodir=./test-macro ./ifname_test* 2>&1 | grep "DEF_VAR_1 .*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 ifnames-test-2.c run failed"
  ifnames-2.13 --macrodir=./test-macro ./ifname_test* 2>&1 | grep "DEF_VAR_1 .*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 ifnames-test-1.c run failed"
  ifnames-2.13 --macrodir=./test-macro ./ifname_test* 2>&1 | grep "IFNDEF_VAR.*1\.c.*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 multi source file run failed"
  ifnames-2.13 --macrodir=./test-macro ./ifname_test* 2>&1 | grep "ifnames-test-3\.c"
  CHECK_RESULT $? 1 0 "Error: ifnames-2.13 ifnames-test-3.c(ineligible) source file run failed"

    LOG_INFO "End to run test."
}

function post_test() {
  rm -rf "$OET_PATH"/testcases/cli-test/autoconf213/common/test-macro
  DNF_REMOVE
  LOG_INFO "Test environment restored."
}

main "$@"
