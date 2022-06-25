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
  LOG_INFO "Test for ifnames-2.13 [-m dir] [--macrodir=dir] [FILE]"
  DNF_INSTALL autoconf213
  LOG_INFO "Test environment is ready."
}

function run_test() {
  LOG_INFO "Start to run test."
  LOG_INFO "$OET_PATH"/testcases/autoconf213/common/ifname_test/
  cd "$OET_PATH"/testcases/autoconf213/common/ifname_test/ || exit
  ifnames-2.13 ./* 2>&1 | grep "DEF_VAR_1 .*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 ifnames-test-2.c run failed"
  ifnames-2.13 ./* 2>&1 | grep "DEF_VAR_1 .*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 ifnames-test-1.c run failed"
  ifnames-2.13 ./* 2>&1 | grep "IFNDEF_VAR.*1\.c.*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 multi source file run failed"
  ifnames-2.13 ./* 2>&1 | grep "ifnames-test-3\.c"
  CHECK_RESULT $? 1 0 "Error: ifnames-2.13 ifnames-test-3.c(ineligible) source file run failed"

  # [-m dir] [--macrodir=dir]
  cd "$OET_PATH"/testcases/autoconf213/common/ || exit
  ifnames-2.13 -m ./test-macro ./ifname_test/* 2>&1 | grep "DEF_VAR_1 .*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 ifnames-test-2.c run failed"
  ifnames-2.13 -m ./test-macro ./ifname_test/* 2>&1 | grep "DEF_VAR_1 .*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 ifnames-test-1.c run failed"
  ifnames-2.13 -m ./test-macro ./ifname_test/* 2>&1 | grep "IFNDEF_VAR.*1\.c.*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 multi source file run failed"
  ifnames-2.13 -m ./test-macro ./ifname_test/* 2>&1 | grep "ifnames-test-3\.c"
  CHECK_RESULT $? 1 0 "Error: ifnames-2.13 ifnames-test-3.c(ineligible) source file run failed"

  cd "$OET_PATH"/testcases/autoconf213/common/ || exit
  ifnames-2.13 --macrodir=./test-macro ./ifname_test/* 2>&1 | grep "DEF_VAR_1 .*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 ifnames-test-2.c run failed"
  ifnames-2.13 --macrodir=./test-macro ./ifname_test/* 2>&1 | grep "DEF_VAR_1 .*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 ifnames-test-1.c run failed"
  ifnames-2.13 --macrodir=./test-macro ./ifname_test/* 2>&1 | grep "IFNDEF_VAR.*1\.c.*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 multi source file run failed"
  ifnames-2.13 --macrodir=./test-macro ./ifname_test/* 2>&1 | grep "ifnames-test-3\.c"
  CHECK_RESULT $? 1 0 "Error: ifnames-2.13 ifnames-test-3.c(ineligible) source file run failed"

  LOG_INFO "End of the ifnames test."
}

function post_test() {
  # rm -f temp-autoconf_test-1.c temp-autoconf_test-2.c temp-autoconf_test-3.c # clean the autoconf_test files
  DNF_REMOVE
  LOG_INFO "Test environment restored."
}

main "$@"
