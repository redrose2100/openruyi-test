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
# @Author    :   lihuan
# @Contact   :   lihuan@uniontech.com
# @Date      :   2024-02-22
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-top
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG="$LANG"
    export LANG=en_US.UTF-8
    rm -rf /tmp/testtop
    mkdir -p /tmp/testtop
    touch /tmp/testtop/top_output.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    # 启动 top 命令，并将其输出重定向到文件，并将进程号赋值给top_pid
    top -b  > /tmp/testtop/top_output.txt &
    top_pid=$!
    # 等待一段时间，让 top 命令运行一段时间
    sleep 1
    # 终止 top 进程
    pkill  $top_pid
    # 测试top的动态输出结果
    grep "root" /tmp/testtop/top_output.txt
    CHECK_RESULT $?

    # 测试 top -o %CPU 命令，按照 CPU 使用率排序输出，并检查输出结果是否按照 CPU 使用率从高到低排序
    top -n 1 -b -o %CPU | grep  "root" # 检查输出结果是否包含root
    CHECK_RESULT $?

    # 测试 top -o %MEM 命令，按照内存使用率排序输出，并检查输出结果是否按照内存使用率从高到低排序
    top -n 1 -b -o %MEM | grep  "root" # 检查输出结果是否包含root
    CHECK_RESULT $?

    # 测试 top -u 命令，显示指定用户的进程
    top -n 1 -b -u root | grep "root"
    CHECK_RESULT $?

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=${OLD_LANG}
    rm -rf /tmp/testtop
    LOG_INFO "End to restore the test environment."
}

main "$@"
