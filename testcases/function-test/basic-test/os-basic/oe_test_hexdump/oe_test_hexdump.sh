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
# @Date      :   2023/11/04
# @License   :   Mulan PSL v2
# @Desc      :   Using the Hexdump command
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    cat > hello.c <<EOF
#include <stdio.h>

int
main ()
{
  printf ("Hello, World!\\n");
  return 0;
}
EOF
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    hexdump -C hello.c > a.log 2>&1
    grep -i World a.log
    CHECK_RESULT $? 0 0 "File view failed"
    hexdump -c hello.c > a.log 2>&1
    grep "W   o   r   l   d" a.log
    CHECK_RESULT $? 0 0 "File view failed"
    hexdump -e '16/1 "%02x " "\n"' -e '16/1 "%3d " "\n"' hello.c > a.log 2>&1
    grep 23 a.log
    CHECK_RESULT $? 0 0 "File view failed"
    hexdump -d hello.c > a.log 2>&1
    grep 0000000 a.log
    CHECK_RESULT $? 0 0 "File view failed"
    hexdump -b hello.c > a.log 2>&1
    grep 043 a.log
    CHECK_RESULT $? 0 0 "File view failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf hello.c a.log
    LOG_INFO "End to restore the test environment."
}

main "$@"