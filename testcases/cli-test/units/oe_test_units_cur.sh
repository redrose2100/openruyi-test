#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2023/7/23
# @License   :   Mulan PSL v2
# @Desc      :   Test "units_cur" command
# ##################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test(){
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "units"
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    units_cur -h | grep "usage: units_cur"
    CHECK_RESULT $? 0 0 "Check units_cur -h failed"
    units_cur --help | grep "usage: units_cur"
    CHECK_RESULT $? 0 0 "Check units_cur --help failed"
    units_cur -V | grep "units_cur version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check units_cur -V failed"
    units_cur --version | grep "units_cur version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check units_cur --version failed"

    check_v=1
    while true;
    do
        if units_cur -v; then
            check_v=0
            break
        fi
    done
    CHECK_RESULT "$check_v" 0 0 "Check units_cur -v failed"
    
    check_verbose=1
    while true;
    do
        if units_cur --verbose; then
            check_verbose=0
            break
        fi
    done 
    CHECK_RESULT "$check_verbose" 0 0 "Check units_cur --verbose failed"

    check_iso=1
    while true;
    do
        if units_cur - | grep "# ISO Currency Codes"; then
            check_iso=0
            break
        fi
    done 
    CHECK_RESULT "$check_iso" 0 0 "Check units_cur filename failed"

    check_s=1
    while true;
    do
        if units_cur -s floatrates; then
            check_s=0
            break
        fi
    done 
    CHECK_RESULT "$check_s" 0 0 "Check units_cur -s failed"

    check_source=1
    while true;
    do
        if units_cur --source floatrates; then
            check_source=0
            break
        fi
    done 
    CHECK_RESULT "$check_source" 0 0 "Check units_cur --source failed"

    check_b=1
    while true;
    do
        if units_cur -b USD; then
            check_b=0
            break
        fi
    done 
    CHECK_RESULT "$check_b" 0 0 "Check units_cur -b failed"

    check_base=1
    while true;
    do
        if units_cur --base USD; then
            check_base=0
            break
        fi
    done 
    CHECK_RESULT "$check_base" 0 0 "Check units_cur --base failed"

    # 需要先在https://www.exchangerate-api.com/注册账号申请KEY
    check_k=1
    while true;
    do
        if units_cur -k KEY; then
            check_k=0
            break
        fi
    done 
    CHECK_RESULT "$check_k" 0 0 "Check units_cur -k failed"

    check_key=1
    while true;
    do
        if units_cur --key KEY; then
            check_key=0
            break
        fi
    done 
    CHECK_RESULT "$check_key" 0 0 "Check units_cur --key failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"