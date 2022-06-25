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
  rm -f "$OET_PATH"/testcases/autoconf213/common/autoconf_test/configure
  rm -f "$OET_PATH"/testcases/autoconf213/common/autoconf_test/config.h.in
  rm -rf "$OET_PATH"/testcases/autoconf213/common/autoconf_test/autom4te.cache/
  LOG_INFO "Test environment is ready."
}

function run_test() {
  LOG_INFO "Start to run test."
  LOG_INFO "$OET_PATH"/testcases/autoconf213/common/autoconf_test/

  cd "$OET_PATH"/testcases/autoconf213/common/autoconf_test/ || exit
  # shellcheck disable=SC2006
  # LOG_INFO "`ls | grep config`"
  autoheader-2.13 2>&1
  CHECK_RESULT $? 0 0 "Error: autoheader-2.13 run failed."
  ls "$OET_PATH"/testcases/autoconf213/common/autoconf_test/ | grep "config.h.in"
  CHECK_RESULT $? 0 0 "Error: config.h.in file failed to generate."

  rm -f "$OET_PATH"/testcases/autoconf213/common/autoconf_test/config.h.in

  # with Library directories [-l dir] [--localdir=dir]
  autoheader-2.13 --localdir="$OET_PATH"/testcases/autoconf213/common/autoconf_test/acconfig.h 2>&1
  CHECK_RESULT $? 0 0 "Error: autoheader-2.13 [--localdir] run failed."
  ls "$OET_PATH"/testcases/autoconf213/common/autoconf_test/ | grep "config.h.in"
  CHECK_RESULT $? 0 0 "Error: [--localdir] configure file failed to generate."

  rm -f "$OET_PATH"/testcases/autoconf213/common/autoconf_test/config.h.in
  autoheader-2.13 -l "$OET_PATH"/testcases/autoconf213/common/autoconf_test/acconfig.h 2>&1
  CHECK_RESULT $? 0 0 "Error: autoheader-2.13 [-l] run failed."
  ls "$OET_PATH"/testcases/autoconf213/common/autoconf_test/ | grep "config.h.in"
  CHECK_RESULT $? 0 0 "Error: [-l] configure file failed to generate."

  # with custom MACRO [--macrodir=dir] [-m dir]
  rm -f "$OET_PATH"/testcases/autoconf213/common/autoconf_test/config.h.in
  autoheader-2.13 --macrodir="$OET_PATH"/testcases/autoconf213/common/test-macro 2>&1
  CHECK_RESULT $? 0 0 "Error: autoheader-2.13 [--macrodir] run failed."
  ls "$OET_PATH"/testcases/autoconf213/common/autoconf_test/ | grep "config.h.in"
  CHECK_RESULT $? 0 0 "Error: [--macrodir] configure file failed to generate."

  rm -f "$OET_PATH"/testcases/autoconf213/common/autoconf_test/config.h.in
  autoheader-2.13 -m "$OET_PATH"/testcases/autoconf213/common/test-macro 2>&1
  CHECK_RESULT $? 0 0 "Error: autoheader-2.13 [-m] run failed."
  ls "$OET_PATH"/testcases/autoconf213/common/autoconf_test/ | grep "config.h.in"
  CHECK_RESULT $? 0 0 "Error: [-m] configure file failed to generate."

  LOG_INFO "End of the autoheader test."
}

function post_test() {
  DNF_REMOVE
  rm -f "$OET_PATH"/testcases/autoconf213/common/autoconf_test/config.h.in
  LOG_INFO "Test environment restored."
}

main "$@"
