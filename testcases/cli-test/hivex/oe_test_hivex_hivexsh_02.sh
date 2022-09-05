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

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."

    # test command: hivexsh

    # SYNOPSIS: hivexsh [-duwf] [hivefile]

    # test hivexsh command: ls
    echo -e "load minimal \n ls" | hivexsh | grep "root"
    CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'ls'"

    # test hivexsh command: add
    echo -e "load minimal \n add test \n ls" | hivexsh -w | grep "test"
    CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'add'"

    # test hivexsh command: cd
    echo -e "load minimal \n cd root" | hivexsh
    CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'cd'"

    # test hivexsh command: lsval
    echo -e "load minimal \n cd root \n lsval @" | hivexsh | grep "Root"
    CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'lsval'"

    # test hivexsh command: setval
    echo -e "load minimal \n add test \n cd test \n setval 1 \n@\nstring:Test\n lsval" | hivexsh -w | grep "Test"
    CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'setval'"

    # test hivexsh command: del
    echo -e "load minimal \n cd root \n del \n ls" | hivexsh -w | grep "root"
    CHECK_RESULT $? 1 0 "hivexsh: faild to test command 'del'"

    # test command: commit
    echo -e "add test \n commit modified_02 \n" | hivexsh -w minimal && test $(find . -type f -name "modified_02") = "./modified_02"
    CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'commit'"
    
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    rm -rf minimal modified_02

    DNF_REMOVE 1 "hivex"

    LOG_INFO "End to restore the test environment."
}

main "$@"