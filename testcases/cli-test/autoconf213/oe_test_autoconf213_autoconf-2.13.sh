#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2022/6/23
# @Desc      :   Test "autoconf" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start to prepare the test environment."

  # [--macrodir=dir] [-l dir] [--localdir=dir] [template-file]
  DNF_INSTALL autoconf213

  # test_macro
  cd "$OET_PATH"/testcases/cli-test/autoconf213/common || exit
  cp ./configure_autoconf.in ./configure.in
  cp -r /usr/share/autoconf-2.13 ./test-macro
  LOG_INFO "Test environment is ready."
}

function run_test() {
  LOG_INFO "Start to run test."
  cd "$OET_PATH"/testcases/cli-test/autoconf213/common || exit
  autoconf-2.13 2>&1
  CHECK_RESULT $? 0 0 "Error: autoconf-2.13 run failed."
  ls | grep "configure" | grep -v "configure."
  CHECK_RESULT $? 0 0 "Error: configure file failed to generate."

  rm -f "$OET_PATH"/testcases/cli-test/autoconf213/common/configure

  # with Library directories [-l dir] [--localdir=dir]
  autoconf-2.13 --localdir="$OET_PATH"/testcases/cli-test/autoconf213/test-macro/acconfig.h 2>&1
  CHECK_RESULT $? 0 0 "Error: autoconf-2.13 [--localdir] run failed."
  ./configure --version | grep "version"
  CHECK_RESULT $? 0 0 "Error: [--localdir] configure file failed to generate."

  rm -f "$OET_PATH"/testcases/cli-test/autoconf213/common/configure

  autoconf-2.13 -l "$OET_PATH"/testcases/cli-test/autoconf213/test-macro/acconfig.h 2>&1
  CHECK_RESULT $? 0 0 "Error: autoconf-2.13 [-l] run failed."
  "$OET_PATH"/testcases/cli-test/autoconf213/common/configure --version | grep "version"
  CHECK_RESULT $? 0 0 "Error: [-l] configure file failed to generate."

  # with custom MACRO [-m dir] [--macrodir=dir]
  rm -f "$OET_PATH"/testcases/cli-test/autoconf213/common/configure
  autoconf-2.13 -m "$OET_PATH"/testcases/cli-test/autoconf213/common/test-macro 2>&1
  CHECK_RESULT $? 0 0 "Error: autoconf-2.13 [-m dir] run failed."
  "$OET_PATH"/testcases/cli-test/autoconf213/common/configure --version | grep "version"
  CHECK_RESULT $? 0 0 "Error: [-m dir] configure file failed to generate."

  rm -f "$OET_PATH"/testcases/cli-test/autoconf213/common/configure
  autoconf-2.13 --macrodir="$OET_PATH"/testcases/cli-test/autoconf213/common/test-macro 2>&1
  CHECK_RESULT $? 0 0 "Error: autoconf-2.13 [--macrodir] run failed."
  "$OET_PATH"/testcases/cli-test/autoconf213/common/configure --version | grep "version"
  CHECK_RESULT $? 0 0 "Error: [--macrodir] configure file failed to generate."

    LOG_INFO "End to run test."
}

function post_test() {
  # rm -f temp-autoconf_test-1.c temp-autoconf_test-2.c temp-autoconf_test-3.c # clean the autoconf_test files
  DNF_REMOVE
  rm -f "$OET_PATH"/testcases/cli-test/autoconf213/common/configure
  rm -f "$OET_PATH"/testcases/cli-test/autoconf213/common/configure.in
  rm -rf "$OET_PATH"/testcases/cli-test/autoconf213/common/test-macro
  LOG_INFO "Test environment restored."
}

main "$@"
