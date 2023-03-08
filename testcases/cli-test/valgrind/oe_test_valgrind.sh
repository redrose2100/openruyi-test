#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   fuyh2020
# @Contact   :   fuyahong@uniontech.com
# @Date      :   2022-11-22
# @License   :   Mulan PSL v2
# @Desc      :   Command test valgrind
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "valgrind glibc-devel glibc-debuginfo"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    valgrind --version | grep -E "valgrind-[0-9]+.[0-9]+.[0-9]+"
    CHECK_RESULT $? 0 0 "check valgrind version error"
    cat > valgrind_test.c << EOF
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    char *p = malloc(sizeof(char) * 8);
    return 0;
}
EOF
    gcc -g -o valgrind_test valgrind_test.c
    CHECK_RESULT $? 0 0 "compile valgrind_test error"
    valgrind --tool=memcheck --leak-check=full ./valgrind_test > valgrind_test.log 2>&1
    CHECK_RESULT $? 0 0 "execute valgrind command error"
    grep "8 bytes in 1 blocks are definitely lost in loss record" valgrind_test.log
    CHECK_RESULT $? 0 0 "check valgrind_test.log error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test*
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
