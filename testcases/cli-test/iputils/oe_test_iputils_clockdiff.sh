#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   hanson_fang
# @Contact   :   490538494@qq.com
# @Date      :   2023/07/19
# @License   :   Mulan PSL v2
# @Desc      :   Test clockdiff command
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "iputils"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    clockdiff -V | grep "clockdiff from iputils"
    CHECK_RESULT $? 0 0 "clockdiff -V execute failed"
    clockdiff --version | grep "clockdiff from iputils"
    CHECK_RESULT $? 0 0 "clockdiff -version execute failed"
    clockdiff -h 2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "clockdiff -h execute failed"
    clockdiff --help 2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "clockdiff --help execute failed"
    if dmidecode -s system-product-name | grep Virtual; then
        clockdiff -o "${NODE2_IPV4}"
        CHECK_RESULT $? 0 0 "clockdiff -o execute failed"
        clockdiff -o1 "${NODE2_IPV4}"
        CHECK_RESULT $? 0 0 "clockdiff -o1 execute failed"
        clockdiff -T ctime "${NODE2_IPV4}"
        CHECK_RESULT $? 0 0 "clockdiff -T ctime execute failed"
        clockdiff --time-format ctime "${NODE2_IPV4}"
        CHECK_RESULT $? 0 0 "clockdiff --time-format execute failed"
        clockdiff -I "${NODE2_IPV4}"
        CHECK_RESULT $? 0 0 "clockdiff -I execute failed"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
