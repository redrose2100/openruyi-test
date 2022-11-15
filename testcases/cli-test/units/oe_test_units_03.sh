#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   huangjiayi
# @Contact   :   1960887351@qq.com
# @Date      :   2022/9/23
# @License   :   Mulan PSL v2
# @Desc      :   Test "python-gitlab" command
# ##################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test(){
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "units"
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    units -u gauss & echo "exit"
    CHECK_RESULT $? 0 0 "Check units -u failed"
    units --units gauss & echo "exit"
    CHECK_RESULT $? 0 0 "Check units --units failed"
    units -V | grep "GNU Units version 2.21"
    CHECK_RESULT $? 0 0 "Check units -V failed"
    units --version | grep "GNU Units version 2.21"
    CHECK_RESULT $? 0 0 "Check units --version failed"
    units -I | grep "GNU Units version 2.21"
    CHECK_RESULT $? 0 0 "Check units -I failed"
    units --info | grep "GNU Units version 2.21"
    CHECK_RESULT $? 0 0 "Check units --info failed"

    units_cur -h | grep "usage: units_cur"
    CHECK_RESULT $? 0 0 "Check units_cur -h failed"
    units_cur --help | grep "usage: units_cur"
    CHECK_RESULT $? 0 0 "Check units_cur --help failed"
    units_cur -V | grep "units_cur version 5.0"
    CHECK_RESULT $? 0 0 "Check units_cur -V failed"
    units_cur --version | grep "units_cur version 5.0"
    CHECK_RESULT $? 0 0 "Check units_cur --version failed"
    units_cur -v
    CHECK_RESULT $? 0 0 "Check units_cur -v failed"
    units_cur --verbose
    CHECK_RESULT $? 0 0 "Check units_cur --verbose failed"
    units_cur -s floatrates
    CHECK_RESULT $? 0 0 "Check units_cur -s failed"
    units_cur --source floatrates
    CHECK_RESULT $? 0 0 "Check units_cur --source failed"
    units_cur -b USD
    CHECK_RESULT $? 0 0 "Check units_cur -b failed"
    units_cur --base USD
    CHECK_RESULT $? 0 0 "Check units_cur --base failed"
    LOG_INFO "End to run test."
    units_cur -k KEY
    CHECK_RESULT $? 0 0 "Check units_cur -k failed"
    units_cur --key KEY
    CHECK_RESULT $? 0 0 "Check units_cur --key failed"
    units_cur - | grep "# ISO Currency Codes"
    CHECK_RESULT $? 0 0 "Check units_cur filename failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"