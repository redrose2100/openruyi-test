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
# @Author    :   xuewenzhen
# @Contact   :   xuewenzhen1@huawei-partners.com
# @Date      :   2024-08-23
# @License   :   Mulan PSL v2
# @Desc      :   package glib2 test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "glib2 glib2-devel gcc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep glib2
    CHECK_RESULT $? 0 0 "The system does not install glib2"
    cat<<EOF>test.c
#include <glib.h>
int main(void)
{
g_print("Hello, world!\n");
return 0;
}
EOF

    CHECK_RESULT $? 0 0 "Test. c write error"
    gcc test.c $(pkg-config --cflags --libs glib-2.0) -o hello
    CHECK_RESULT $? 0 0 "Compilation failed, no hello binary is generated"
    ./hello | grep Hello
    CHECK_RESULT $? 0 0 "not Print Hello, world!"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f test.c hello
    LOG_INFO "End to restore the test environment."
}

main $@
