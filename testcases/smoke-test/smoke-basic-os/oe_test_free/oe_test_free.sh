#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangliang
#@Contact   	:   wangliang4@uniontech.com
#@Date      	:   2024-09-23
#@License   	:   Mulan PSL v2
#@Desc      	:   test free
#####################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare environment."
    LOG_INFO "End to prepare environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    free | grep "Mem:"
    CHECK_RESULT $? 0 0  "test free:mem fail"
    free | grep "Swap:"
    CHECK_RESULT $? 0 0  "test free:swap fail"

    free -b
    CHECK_RESULT $? 0 0  "check arguments -b fail"

    free -m
    CHECK_RESULT $? 0 0  "check arguments -m fail"

    free -k
    CHECK_RESULT $? 0 0  "check arguments -k fail"

    free -g
    CHECK_RESULT $? 0 0  "check arguments -g fail"

    free -h
    CHECK_RESULT $? 0 0  "check arguments -h fail"

    free -l | grep "Low:"
    CHECK_RESULT $? 0 0  "check arguments -l fail"
    free -l | grep "High:"
    CHECK_RESULT $? 0 0  "check arguments -l fail"

    free -t | grep "Total:"
    CHECK_RESULT $? 0 0  "check arguments -t fail"

    timeout 12s free -s 3 > /tmp/tmp_free
    test "$((12 / 3))" == "$(grep -c "Swap" /tmp/tmp_free)"
    CHECK_RESULT $? 0 0  "check arguments -s fail"

    free -c 6 > /tmp/tmp_free
    test "6" == "$(grep -c "Mem" /tmp/tmp_free)"
    CHECK_RESULT $? 0 0  "check arguments -c fail"

    free -V
    CHECK_RESULT $? 0 0  "check arguments -V fail"
    LOG_INFO "Finish test."
}

function post_test() {
    LOG_INFO "Start to restore environment."
    rm -rf /tmp/tmp_free
    LOG_INFO "Finish restoring environment."
}

main "$@"



