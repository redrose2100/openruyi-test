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
# @Desc      :   Test "autoheader-2.13" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Test for autoheader"
  # [-m dir] [--macrodir=dir] [-l dir] [--localdir=dir] [template-file]
  DNF_INSTALL autoconf213
  rm -f "$OET_PATH"/testcases/cli-test/autoconf213/configure
  rm -f "$OET_PATH"/testcases/cli-test/autoconf213/config.h.in
  rm -rf "$OET_PATH"/testcases/cli-test/autoconf213/autom4te.cache/
  # init test files
  cat > "$OET_PATH"/testcases/cli-test/autoconf213/configure.in <<EOF
AC_PREREQ([2.13])
AC_INIT([autoupdate-test], [1.0], [test@example.com])
AC_PROG_CC
AC_OUTPUT(Makefile)
EOF
  cat > "$OET_PATH"/testcases/cli-test/autoconf213/autoconf-test.c <<EOF
#include "stdio.h"
#include "stdlib.h"

int main(int argc, char** argv){
    printf("Hello Autoconf-213")
    return 0;
}
EOF
  # test_macro
  cp -r /usr/share/autoconf-2.13 "$OET_PATH"/testcases/cli-test/autoconf213/test-macro
  LOG_INFO "Test environment is ready."
}

function run_test() {
  LOG_INFO "Start to run test."
  LOG_INFO "$OET_PATH"/testcases/cli-test/autoconf213/

  cd "$OET_PATH"/testcases/cli-test/autoconf213/ || exit
  LOG_DEBUG $(ll | grep config)
  autoheader-2.13 2>&1
  CHECK_RESULT $? 0 0 "Error: autoheader-2.13 run failed."
  ls "$OET_PATH"/testcases/cli-test/autoconf213/ | grep "config.h.in"
  CHECK_RESULT $? 0 0 "Error: config.h.in file failed to generate."

  rm -f "$OET_PATH"/testcases/cli-test/autoconf213/config.h.in

  # with Library directories [-l dir] [--localdir=dir]
  autoheader-2.13 --localdir="$OET_PATH"/testcases/cli-test/autoconf213/test-macro/acconfig.h 2>&1
  CHECK_RESULT $? 0 0 "Error: autoheader-2.13 [--localdir] run failed."
  ls "$OET_PATH"/testcases/cli-test/autoconf213/ | grep "config.h.in"
  CHECK_RESULT $? 0 0 "Error: [--localdir] configure file failed to generate."

  rm -f "$OET_PATH"/testcases/cli-test/autoconf213/config.h.in
  autoheader-2.13 -l "$OET_PATH"/testcases/cli-test/autoconf213/test-macro/acconfig.h 2>&1
  CHECK_RESULT $? 0 0 "Error: autoheader-2.13 [-l] run failed."
  ls "$OET_PATH"/testcases/cli-test/autoconf213/ | grep "config.h.in"
  CHECK_RESULT $? 0 0 "Error: [-l] configure file failed to generate."

  # with custom MACRO [--macrodir=dir] [-m dir]
  rm -f "$OET_PATH"/testcases/cli-test/autoconf213/config.h.in
  autoheader-2.13 --macrodir="$OET_PATH"/testcases/cli-test/autoconf213/common/test-macro 2>&1
  CHECK_RESULT $? 0 0 "Error: autoheader-2.13 [--macrodir] run failed."
  ls "$OET_PATH"/testcases/cli-test/autoconf213/ | grep "config.h.in"
  CHECK_RESULT $? 0 0 "Error: [--macrodir] configure file failed to generate."

  rm -f "$OET_PATH"/testcases/cli-test/autoconf213/config.h.in
  autoheader-2.13 -m "$OET_PATH"/testcases/cli-test/autoconf213/common/test-macro 2>&1
  CHECK_RESULT $? 0 0 "Error: autoheader-2.13 [-m] run failed."
  ls "$OET_PATH"/testcases/cli-test/autoconf213/ | grep "config.h.in"
  CHECK_RESULT $? 0 0 "Error: [-m] configure file failed to generate."

  LOG_INFO "End of the autoheader test."
}

function post_test() {
  DNF_REMOVE
  rm -f "$OET_PATH"/testcases/cli-test/autoconf213/config.h.in
  rm -f "$OET_PATH"/testcases/cli-test/autoconf213/configure.in*
  rm -f "$OET_PATH"/testcases/cli-test/autoconf213/autoconf-test.c
  rm -rf "$OET_PATH"/testcases/cli-test/autoconf213/test-macro
  LOG_INFO "Test environment restored."
}

main "$@"
