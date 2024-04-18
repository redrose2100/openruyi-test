#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   leepeng
# @Contact   :   lipeng2@uniontech.com
# @Date      :   2024.3.30
# @License   :   Mulan PSL v2
# @Desc      :   systemcall getpid() test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL gcc
    mkdir -p /tmp/testsystemcall
    path=/tmp/testsystemcall
    cat >${path}/testge:tpid.c <<EOF
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

int main() {
    pid_t pid;

    // 获取当前进程的PID
    pid = getpid();

    // 打印当前进程的PID
    printf("当前进程的PID是: %d\n", pid);

    return 0;
}
EOF
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    gcc -o ${path}/testgetpid.o  ${path}/testgetpid.c
    ${path}/testgetpid.o | grep PID
    CHECK_RESULT $? 0 0 "systemcall  getpid() test fail"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf ${path}
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
