#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under the Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yanglang
# @Contact   :   yanglang@uniontech.com
# @Date      :   2026-05-18
# @License   :   Mulan PSL v2
# @Desc      :   glibc sendfile system call test
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gcc glibc-devel"
    LOG_INFO "End of environmental preparation!"
}

function run_test()
{
    LOG_INFO "start to run test."

    # 检查 sendfile 头文件是否存在
    ls /usr/include/sys/sendfile.h
    CHECK_RESULT $? 0 0 "sys/sendfile.h not found"

    # 检查 libc 是否包含 sendfile 符号
    nm -D /lib64/libc.so.6 | grep -i sendfile
    CHECK_RESULT $? 0 0 "sendfile symbol not in libc"

    # 编写测试程序调用 sendfile 头文件
    cat > test_sendfile.c << EOF
#include <stdio.h>
#include <sys/sendfile.h>
#include <unistd.h>

int main()
{
    printf("sendfile header included successfully\n");
    return 0;
}
EOF
    CHECK_RESULT $? 0 0 "create test_sendfile.c failed"

    # 编译，无需 -lsendfile
    gcc test_sendfile.c -o test_sendfile
    CHECK_RESULT $? 0 0 "compile test_sendfile.c failed"

    # 运行
    ./test_sendfile
    CHECK_RESULT $? 0 0 "run test_sendfile failed"

    LOG_INFO "All test executed successfully!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    #shellcheck disable=SC2119
    DNF_REMOVE
    rm -rf test_sendfile.c test_sendfile
    LOG_INFO "End to restore the test environment."
}

main "$@"

