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
# @Desc      :   Test hivexget, hivexml
# #############################################

source $OET_PATH/libs/locallibs/common_lib_shell.sh
source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    DNF_INSTALL "hivex"

    cp ./common/minimal ./
    cp ./common/minimal.txt ./

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."

    # test command: hivexget

    # SYNOPSIS: hivexget hivefile path [key]
    hivexget minimal root
    test "$(hivexget minimal root)" = "$(cat minimal.txt)"
    CHECK_RESULT $? 0 0 "hivexget: failed to get hivefile path"

    test "$(hivexget minimal root A)" = "abcd"
    CHECK_RESULT $? 0 0 "hivexget: failed to get hivefile key-value"

    # test command: hivexml

    # SYNOPSIS: hivexml [-dku] hivefile > output.xml
    hivexml -dku minimal > output.xml && test $(find . -type f -name "output.xml") = "./output.xml"
    CHECK_RESULT $? 0 0 "hivexml: failed to convert hivefile to xml"

    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    rm -rf minimal minimal.txt output.xml

    DNF_REMOVE 1 "hivex"

    LOG_INFO "End to restore the test environment."
}

main "$@"