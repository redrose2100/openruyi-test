#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   hantingxiang
# @Contact   :   hantingxiang@gmail.com
# @Date      :   2022/07/26
# @License   :   Mulan PSL v2
# @Desc      :   Test hivexsh
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    DNF_INSTALL "hivex"

    cp ./common/minimal ./
    cp ./common/hivexsh_cmd ./

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."

    # test command: hivexsh

    # SYNOPSIS: hivexsh [-duwf] [hivefile]

    # test option: -d
    echo "quit" | hivexsh -d minimal 2>&1 | grep "hivex: hivex_open"
    CHECK_RESULT $? 0 0 "hivexsh: faild to test options -d"

    # test option: -u
    echo "quit" | hivexsh -u minimal
    CHECK_RESULT $? 0 0 "hivexsh: faild to test options -u"

    # test option: -w
    echo "add test" | hivexsh -w minimal | grep "Read-only file system"
    CHECK_RESULT $? 1 0 "hivexsh: faild to test options -w"

    # test option: -f
    hivexsh -wf hivexsh_cmd && test $(find . -type f -name "modified_01") = "./modified_01"
    CHECK_RESULT $? 0 0 "hivexsh: faild to test options -f"

    # test hivexsh command: help
    echo "help" | hivexsh | grep -E "Navigate through the hive's keys using the 'cd' command|使用 'cd' 命令在 hive 键之间跳转"
    CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'help'"

    # test hivexsh command: quit
    echo "quit" | hivexsh
    CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'quit'"

    # test hivexsh command: exit
    echo "exit" | hivexsh
    CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'exit'"

    # test hivexsh command: load
    echo "load minimal" | hivexsh
    CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'load'"

    # test hivexsh command: close
    echo -e "load minimal \n close" | hivexsh
    CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'close'"

    # test hivexsh command: unload
    echo -e "load minimal \n unload" | hivexsh
    CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'unload'"

    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    rm -rf minimal hivexsh_cmd modified_01

    DNF_REMOVE 1 "hivex"

    LOG_INFO "End to restore the test environment."
}

main "$@"