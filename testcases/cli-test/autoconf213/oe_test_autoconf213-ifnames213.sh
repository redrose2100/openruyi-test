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
  # init test files
  cat > "$OET_PATH"/testcases/cli-test/autoconf213/ifname_test-1.c <<EOF
#include "stdio.h"
#include "stdlib.h"

#define DEF_VAR_1 DEF_VAR_2 10
#ifndef IFNDEF_VAR
#define IFNDEF_VAR DEF_VAR_1
#endif

#if (DEF_VAR_2 > 0)
#define IF_VAR DEF_VAR_2+10
#endif

int main(int argc, char** argv){
    printf("This is 1st autoconf_test file.")
    return 0;
}
EOF
  cat > "$OET_PATH"/testcases/cli-test/autoconf213/ifname_test-2.c <<EOF
#include "stdio.h"
#include "stdlib.h"

#define DEF_VAR_1 DEF_VAR_2 10
#ifndef IFNDEF_VAR
    #define IFNDEF_VAR DEF_VAR_1
#endif

#if (DEF_VAR_1 > 0)
    #define IF_VAR DEF_VAR_2+10
#endif

int main(int argc, char** argv){
    printf("This is 2nd autoconf_test file.")
    return 0;
}

EOF
  cat > "$OET_PATH"/testcases/cli-test/autoconf213/ifname_test-3.c <<EOF
  #include "stdio.h"
  #include "stdlib.h"

  int main(int argc, char** argv){
      printf("This is 3rd autoconf_test file.")
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
  ifnames-2.13 ./ifname_test* 2>&1 | grep "DEF_VAR_1 .*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 ifnames-test-2.c run failed"
  ifnames-2.13 ./ifname_test* 2>&1 | grep "DEF_VAR_1 .*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 ifnames-test-1.c run failed"
  ifnames-2.13 ./ifname_test* 2>&1 | grep "IFNDEF_VAR.*1\.c.*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 multi source file run failed"
  ifnames-2.13 ./ifname_test* 2>&1 | grep "ifnames-test-3\.c"
  CHECK_RESULT $? 1 0 "Error: ifnames-2.13 ifnames-test-3.c(ineligible) source file run failed"

  # [-m dir] [--macrodir=dir]
  cd "$OET_PATH"/testcases/cli-test/autoconf213/ || exit
  ifnames-2.13 -m ./test-macro ./ifname_test* 2>&1 | grep "DEF_VAR_1 .*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 ifnames-test-2.c run failed"
  ifnames-2.13 -m ./test-macro ./ifname_test* 2>&1 | grep "DEF_VAR_1 .*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 ifnames-test-1.c run failed"
  ifnames-2.13 -m ./test-macro ./ifname_test* 2>&1 | grep "IFNDEF_VAR.*1\.c.*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 multi source file run failed"
  ifnames-2.13 -m ./test-macro ./ifname_test* 2>&1 | grep "ifnames-test-3\.c"
  CHECK_RESULT $? 1 0 "Error: ifnames-2.13 ifnames-test-3.c(ineligible) source file run failed"

  cd "$OET_PATH"/testcases/cli-test/autoconf213/ || exit
  ifnames-2.13 --macrodir=./test-macro ./ifname_test* 2>&1 | grep "DEF_VAR_1 .*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 ifnames-test-2.c run failed"
  ifnames-2.13 --macrodir=./test-macro ./ifname_test* 2>&1 | grep "DEF_VAR_1 .*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 ifnames-test-1.c run failed"
  ifnames-2.13 --macrodir=./test-macro ./ifname_test* 2>&1 | grep "IFNDEF_VAR.*1\.c.*2\.c"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 multi source file run failed"
  ifnames-2.13 --macrodir=./test-macro ./ifname_test* 2>&1 | grep "ifnames-test-3\.c"
  CHECK_RESULT $? 1 0 "Error: ifnames-2.13 ifnames-test-3.c(ineligible) source file run failed"

  LOG_INFO "End of the ifnames test."
}

function post_test() {
  rm -f "$OET_PATH"/testcases/cli-test/autoconf213/ifname_test* # clean the autoconf_test files
  rm -rf "$OET_PATH"/testcases/cli-test/autoconf213/test-macro
  DNF_REMOVE
  LOG_INFO "Test environment restored."
}

main "$@"
