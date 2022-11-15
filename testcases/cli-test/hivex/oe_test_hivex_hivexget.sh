#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
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

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL hivex
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    test "$(hivexget ./common/minimal root)" = "$(cat ./common/minimal.txt)"
    CHECK_RESULT $? 0 0 "hivexget: failed to get hivefile path"
    test "$(hivexget ./common/minimal root A)" = "abcd"
    CHECK_RESULT $? 0 0 "hivexget: failed to get hivefile key-value"
    hivexml -dku ./common/minimal > output.xml
    cat "output.xml" | grep 'key="A" value="abcd"'
    CHECK_RESULT $? 0 0 "hivexml: failed to convert hivefile to xml"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf output.xml
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
