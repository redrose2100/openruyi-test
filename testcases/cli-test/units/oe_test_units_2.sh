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
    units -S &
    echo "exit"
    CHECK_RESULT $? 0 0 "Check units -S failed"
    units -o %.8g &
    echo "exit"
    CHECK_RESULT $? 0 0 "Check units -o failed"
    units -p &
    echo "exit"
    CHECK_RESULT $? 0 0 "Check units -p failed"
    units -q &
    echo "exit"
    CHECK_RESULT $? 0 0 "Check units -q failed"
    units -s &
    echo "exit"
    CHECK_RESULT $? 0 0 "Check units -s failed"
    units -v &
    echo "exit"
    CHECK_RESULT $? 0 0 "Check units -v failed"
    units -1 &
    echo "exit"
    CHECK_RESULT $? 0 0 "Check units -1 failed"
    units -t &
    echo "exit"
    CHECK_RESULT $? 0 0 "Check units -t failed"
    units -r &
    echo "exit"
    CHECK_RESULT $? 0 0 "Check units -r failed"
    units -U | grep "/usr/share/units/definitions.units"
    CHECK_RESULT $? 0 0 "Check units -U failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"