#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2023/08/10
# @License   :   Mulan PSL v2
# @Desc      :   Using the indent command
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "indent"
    cat > hello.c <<EOF
#include <stdio.h>

int
main ()
{
  printf ("Hello, World!\n");
  return 0;
}
EOF
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    indent hello.c
    test -f hello.c~
    CHECK_RESULT $? 0 0 "file does not exist "
    indent -o output.c hello.c
    test -f output.c
    CHECK_RESULT $? 0 0 "file does not exist "
    indent -kr -i8 hello.c
    diff hello.c hello.c~
    CHECK_RESULT $? 0 1 "File Indent Failure"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf hello.c hello.c~ output.c
    LOG_INFO "End to restore the test environment."
}

main "$@"