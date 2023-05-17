#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiechangyan1
# @Contact   :   xiechangyan@uniontech.com
# @Date      :   2023-04-11
# @License   :   Mulan PSL v2
# @Desc      :   Use glibc case
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    pwd=`pwd`
    mkdir glibc_test && cd glibc_test
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    version=`rpm -qa glibc`
    CHECK_RESULT $? 0 0 "Check glibc version"
    cat > glibc-version.c << EOF
#include <stdio.h>
#include <stdlib.h>
#include <gnu/libc-version.h>
int main(int argc, char *argv[])
{
printf("GNU lib version:%s\n",gnu_get_libc_version());
exit(EXIT_SUCCESS);
}
EOF
    CHECK_RESULT $? 0 0 "Fail to create glibc-version.c"
    gcc glibc-version.c
    CHECK_RESULT $? 0 0 "Error,fail to create a.out"
    ./a.out | grep ${version:6:4}
    CHECK_RESULT $? 0 0 "Error,fail to run a.out"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    cd $pwd && rm -rf glibc_test/
    LOG_INFO "End to restore the test environment."
}

main "$@"