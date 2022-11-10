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
    touch test.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    units -h | grep "Usage: units"
    CHECK_RESULT $? 0 0 "Check units -h failed"
    units -c | grep "Currency exchange rates from FloatRates"
    CHECK_RESULT $? 0 0 "Check units -c failed"
    units -d 8 &
    echo "exit"
    CHECK_RESULT $? 0 0 "Check units -d failed"
    units -e &
    echo "exit"
    CHECK_RESULT $? 0 0 "Check units -e failed"
    units -f test.txt &
    echo "exit"
    CHECK_RESULT $? 0 0 "Check units -f failed"
    units -H test.txt &
    echo "exit"
    CHECK_RESULT $? 0 0 "Check units -H failed"
    units -L test.txt &
    echo "exit"
    CHECK_RESULT $? 0 0 "Check units -L failed"
    units -l test.txt &
    echo "exit"
    CHECK_RESULT $? 0 0 "Check units -l failed"
    units -m &
    echo "exit"
    CHECK_RESULT $? 0 0 "Check units -m failed"
    units -n &
    echo "exit"
    CHECK_RESULT $? 0 0 "Check units -n failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf test.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"