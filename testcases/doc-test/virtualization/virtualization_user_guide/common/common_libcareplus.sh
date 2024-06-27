#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhujinlong
#@Contact       :   zhujinlong@163.com
#@Date          :   2023-08-17
#@License       :   Mulan PSL v2
#@Desc          :   Common function: Prepare environment, Create and start a stratovirt VM
#####################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_env() {
    DNF_INSTALL "binutils elfutils elfutils-libelf-devel libunwind-devel libcareplus libcareplus-devel"
    libcare-ctl -h 2>&1 | grep "usage"
    cat >foo.c <<EOF
#include <stdio.h>
#include <time.h>

void print_hello(void)
{
    printf("Hello world!\n");
}

int main(void)
{
    while (1) {
        print_hello();
        sleep(1);
    }
}
EOF
    cat >bar.c <<EOF
#include <stdio.h>
#include <time.h>

void print_hello(void)
{
    printf("Hello world %s!\n", "being patched");
}

int main(void)
{
    while (1) {
        print_hello();
        sleep(1);
    }
}
EOF
}

function clear_env() {
    kill -9 "$(pgrep -f ./foo)"
    rm -rf foo* bar* patchroot lpmake /tmp/tmp* testlog
    DNF_REMOVE "$@"
}
