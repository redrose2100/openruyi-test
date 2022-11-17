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
# @Desc      :   Test "units" command
# ##################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test(){
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "units"
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    units -S & echo "exit"
    CHECK_RESULT $? 0 0 "Check units -S failed"
    units --show-factor & echo "exit"
    CHECK_RESULT $? 0 0 "Check units --show-factor failed"
    units --conformable & echo "exit"
    CHECK_RESULT $? 0 0 "Check units --conformable failed"
    units -o %.8g & echo "exit"
    CHECK_RESULT $? 0 0 "Check units -o failed"
    units --output-format %.8g & echo "exit"
    CHECK_RESULT $? 0 0 "Check units --output-format failed"
    units -p & echo "exit"
    CHECK_RESULT $? 0 0 "Check units -p failed"
    units --product & echo "exit"
    CHECK_RESULT $? 0 0 "Check units --product failed"
    units -q & echo "exit"
    CHECK_RESULT $? 0 0 "Check units -q failed"
    units --quiet & echo "exit"
    CHECK_RESULT $? 0 0 "Check units --quiet failed"
    units --silent & echo "exit"
    CHECK_RESULT $? 0 0 "Check units --silent failed"
    units -s & echo "exit"
    CHECK_RESULT $? 0 0 "Check units -s failed"
    units --strict & echo "exit"
    CHECK_RESULT $? 0 0 "Check units --strict failed"
    units -v & echo "exit"
    CHECK_RESULT $? 0 0 "Check units -v failed"
    units --verbose & echo "exit"
    CHECK_RESULT $? 0 0 "Check units --verbose failed"
    units --compact & echo "exit"
    CHECK_RESULT $? 0 0 "Check units --compact failed"
    units -1 & echo "exit"
    CHECK_RESULT $? 0 0 "Check units -1 failed"
    units --one-line & echo "exit"
    CHECK_RESULT $? 0 0 "Check units --one-line failed"
    units -t & echo "exit"
    CHECK_RESULT $? 0 0 "Check units -t failed"
    units --terse & echo "exit"
    CHECK_RESULT $? 0 0 "Check units --terse failed"
    units -r & echo "exit"
    CHECK_RESULT $? 0 0 "Check units -r failed"
    units --round & echo "exit"
    CHECK_RESULT $? 0 0 "Check units --round failed"
    units -U | grep "/usr/share/units/definitions.units"
    CHECK_RESULT $? 0 0 "Check units -U failed"
    units --unitsfile | grep "/usr/share/units/definitions.units"
    CHECK_RESULT $? 0 0 "Check units --unitsfile failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"