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
# @Desc      :   Test "autoreconf-2.13" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Test for autoreconf"
  LOG_INFO "$OET_PATH"/testcases/autoconf213/common/autoreconf_test/

  rm -f "$OET_PATH"/testcases/autoconf213/common/autoreconf_test/configure
  rm -f "$OET_PATH"/testcases/autoconf213/common/autoreconf_test/configure.bak
  rm -f "$OET_PATH"/testcases/autoconf213/common/autoreconf_test/config.h.in
  rm -rf "$OET_PATH"/testcases/autoconf213/common/autoreconf_test/autom4te.cache/

  DNF_INSTALL autoconf213 automake
  cd "$OET_PATH"/testcases/autoconf213/common/autoreconf_test || exit
  autoconf-2.13 2>&1
  CHECK_RESULT $? 0 0 "Error: autoconf-2.13 run failed."
  ./configure --version | grep "version"
  CHECK_RESULT $? 0 0 "Error: configure file failed to generate."
  cp ./configure ./configure.bak

  LOG_INFO "Test environment is ready."
}

function run_test() {
  LOG_INFO "Start to run test."

  # run test command
  cd "$OET_PATH"/testcases/autoconf213/common/autoreconf_test || exit
  sed -i 's/Makefile/Makefilere/g' configure.in
  autoreconf-2.13 2>&1
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 run failed."
  ./configure --version | grep "version"
  CHECK_RESULT $? 0 0 "Error: configure file failed to generate."
  # check the result
  diff ./configure ./configure.bak | grep "re"
  CHECK_RESULT $? 0 0 "Error: autoreconf failed to re-config."
  sed -i 's/Makefilere/Makefile/g' configure.in
  cp -f ./configure.bak ./configure

  # with Library directories [-l dir] [--localdir=dir]
  cd "$OET_PATH"/testcases/autoconf213/common/autoreconf_test || exit
  sed -i 's/Makefile/Makefilere/g' configure.in
  autoreconf-2.13 --localdir="$OET_PATH"/testcases/autoconf213/common/autoreconf_test/acconfig.h 2>&1
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--localdir] run failed."
  ./configure --version | grep "version"
  CHECK_RESULT $? 0 0 "Error: [--localdir] configure file failed to generate."

  diff ./configure ./configure.bak | grep "re"
  CHECK_RESULT $? 0 0 "Error: autoreconf [--localdir] failed to re-config."
  sed -i 's/Makefilere/Makefile/g' configure.in
  cp -f ./configure.bak ./configure

  cd "$OET_PATH"/testcases/autoconf213/common/autoreconf_test || exit
  sed -i 's/Makefile/Makefilere/g' configure.in
  autoreconf-2.13 -l "$OET_PATH"/testcases/autoconf213/common/autoreconf_test/acconfig.h 2>&1
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [-l] run failed."
  ./configure --version | grep "version"
  CHECK_RESULT $? 0 0 "Error: [-l] configure file failed to generate."

  diff ./configure ./configure.bak | grep "re"
  CHECK_RESULT $? 0 0 "Error: autoreconf [-l] failed to re-config."
  sed -i 's/Makefilere/Makefile/g' configure.in
  cp -f ./configure.bak ./configure

  # with custom MACRO [--macrodir=dir]
  cd "$OET_PATH"/testcases/autoconf213/common/autoreconf_test || exit
  sed -i 's/Makefile/Makefilere/g' configure.in
  autoreconf-2.13 --macrodir="$OET_PATH"/testcases/autoconf213/common/test-macro 2>&1
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--macrodir] run failed."
  ./configure --version | grep "version"
  CHECK_RESULT $? 0 0 "Error: [--macrodir] configure file failed to generate."

  diff ./configure ./configure.bak | grep "re"
  CHECK_RESULT $? 0 0 "Error: autoreconf [--macrodir] failed to re-config."
  sed -i 's/Makefilere/Makefile/g' configure.in
  cp -f ./configure.bak ./configure

  # [--verbose]
  cd "$OET_PATH"/testcases/autoconf213/common/autoreconf_test || exit
  rm -f "$OET_PATH"/testcases/autoconf213/common/autoreconf_test/configure
  sed -i 's/Makefile/Makefilere/g' configure.in
  autoreconf-2.13 --verbose 2>&1 | grep "running"
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--verbose] run failed."
  ./configure --version | grep "version"
  CHECK_RESULT $? 0 0 "Error: [--verbose] configure file failed to generate."

  diff ./configure ./configure.bak | grep "re"
  CHECK_RESULT $? 0 0 "Error: autoreconf [--verbose] failed to re-config."
  sed -i 's/Makefilere/Makefile/g' configure.in
  cp -f ./configure.bak ./configure

  # [--force]
  cd "$OET_PATH"/testcases/autoconf213/common/autoreconf_test || exit
  rm -f "$OET_PATH"/testcases/autoconf213/common/autoreconf_test/configure
  sed -i 's/Makefile/Makefilere/g' configure.in
  autoreconf-2.13 --force --verbose 2>&1 | grep "running"
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--force] run failed."
  ./configure --version | grep "version"
  CHECK_RESULT $? 0 0 "Error: [--force] configure file failed to generate."

  diff ./configure ./configure.bak | grep "re"
  CHECK_RESULT $? 0 0 "Error: autoreconf [--force] failed to re-config."
  sed -i 's/Makefilere/Makefile/g' configure.in
  cp -f ./configure.bak ./configure

  # [--cygnus]
  cd "$OET_PATH"/testcases/autoconf213/common/autoreconf_test || exit
  rm -f "$OET_PATH"/testcases/autoconf213/common/autoreconf_test/configure
  sed -i 's/Makefile/Makefilere/g' configure.in
  autoreconf-2.13 --cygnus --verbose 2>&1 | grep "running"
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--cygnus] run failed."
  ./configure --version | grep "version"
  CHECK_RESULT $? 0 0 "Error: [--cygnus] configure file failed to generate."

  diff ./configure ./configure.bak | grep "re"
  CHECK_RESULT $? 0 0 "Error: autoreconf [--cygnus] failed to re-config."
  sed -i 's/Makefilere/Makefile/g' configure.in
  cp -f ./configure.bak ./configure

  # [--foreign]
  cd "$OET_PATH"/testcases/autoconf213/common/autoreconf_test || exit
  rm -f "$OET_PATH"/testcases/autoconf213/common/autoreconf_test/configure
  sed -i 's/Makefile/Makefilere/g' configure.in
  autoreconf-2.13 --foreign --verbose 2>&1 | grep "running"
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--foreign] run failed."
  ./configure --version | grep "version"
  CHECK_RESULT $? 0 0 "Error: [--foreign] configure file failed to generate."

  diff ./configure ./configure.bak | grep "re"
  CHECK_RESULT $? 0 0 "Error: autoreconf [--foreign] failed to re-config."
  sed -i 's/Makefilere/Makefile/g' configure.in
  cp -f ./configure.bak ./configure

  #  [--gnits]
  cd "$OET_PATH"/testcases/autoconf213/common/autoreconf_test || exit
  rm -f "$OET_PATH"/testcases/autoconf213/common/autoreconf_test/configure
  sed -i 's/Makefile/Makefilere/g' configure.in
  autoreconf-2.13 --gnits --verbose 2>&1 | grep "running"
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--gnits] run failed."
  ./configure --version | grep "version"
  CHECK_RESULT $? 0 0 "Error: [--gnits] configure file failed to generate."

  diff ./configure ./configure.bak | grep "re"
  CHECK_RESULT $? 0 0 "Error: autoreconf [--gnits] failed to re-config."
  sed -i 's/Makefilere/Makefile/g' configure.in
  cp -f ./configure.bak ./configure

  # [--gnu]
  cd "$OET_PATH"/testcases/autoconf213/common/autoreconf_test || exit
  rm -f "$OET_PATH"/testcases/autoconf213/common/autoreconf_test/configure
  sed -i 's/Makefile/Makefilere/g' configure.in
  autoreconf-2.13 --gnu --verbose 2>&1 | grep "running"
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--gnu] run failed."
  ./configure --version | grep "version"
  CHECK_RESULT $? 0 0 "Error: [--gnu] configure file failed to generate."

  diff ./configure ./configure.bak | grep "re"
  CHECK_RESULT $? 0 0 "Error: autoreconf [--gnu] failed to re-config."
  sed -i 's/Makefilere/Makefile/g' configure.in
  cp -f ./configure.bak ./configure

  # [-i] [--include-deps]
  cd "$OET_PATH"/testcases/autoconf213/common/autoreconf_test/ || exit
  rm -f "$OET_PATH"/testcases/autoconf213/common/autoreconf_test/configure
  sed -i 's/Makefile/Makefilere/g' "$OET_PATH"/testcases/autoconf213/common/autoreconf_test/configure.in
  autoreconf-2.13 -i --verbose 2>&1 | grep "running"
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [-i] run failed."
  ./configure --version | grep "version"
  CHECK_RESULT $? 0 0 "Error: [-i] configure file failed to generate."

  diff ./configure ./configure.bak | grep "re"
  CHECK_RESULT $? 0 0 "Error: autoreconf [-i] failed to re-config."
  sed -i 's/Makefilere/Makefile/g' ./configure.in
  cp -f ./configure.bak ./configure

  cd "$OET_PATH"/testcases/autoconf213/common/autoreconf_test/ || exit
  rm -f ./configure
  sed -i 's/Makefile/Makefilere/g' ./configure.in
  autoreconf-2.13 --include-deps --verbose 2>&1 | grep "running"
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--include-deps] run failed."
  ./configure --version | grep "version"
  CHECK_RESULT $? 0 0 "Error: [--include-deps] configure file failed to generate."

  diff ./configure ./configure.bak | grep "re"
  CHECK_RESULT $? 0 0 "Error: autoreconf [--include-deps] failed to re-config."
  sed -i 's/Makefilere/Makefile/g' ./configure.in
  cp -f ./configure.bak ./configure

  LOG_INFO "End of the autoreconf test."
}

function post_test() {
  DNF_REMOVE
  rm -f "$OET_PATH"/testcases/autoconf213/common/autoreconf_test/configure
  rm -f "$OET_PATH"/testcases/autoconf213/common/autoreconf_test/configure.bak
  rm -f "$OET_PATH"/testcases/autoconf213/common/autoreconf_test/config.h.in
  rm -rf "$OET_PATH"/testcases/autoconf213/common/autoreconf_test/autom4te.cache/
  LOG_INFO "Test environment restored."
}

main "$@"
