#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of perl-libwww-perl command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL perl-libwww-perl
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    GET -u http://www.baidu.com 2>&1 | grep 'http://www.baidu.com'
    CHECK_RESULT $? 0 0 "Check GET -u failed"
    GET -U http://www.baidu.com 2>&1 | grep 'request'
    CHECK_RESULT $? 0 0 "Check GET -U failed"
    GET -s http://www.baidu.com 2>&1 | grep 'STATUS OK'
    CHECK_RESULT $? 0 0 "Check GET -s failed"
    GET -S http://www.baidu.com 2>&1 | grep 'response'
    CHECK_RESULT $? 0 0 "Check GET -S failed"
    GET -e http://www.baidu.com 2>&1 | grep '"Content-Type'
    CHECK_RESULT $? 0 0 "Check GET -e failed"
    GET -E http://www.baidu.com 2>&1 | grep 'headers'
    CHECK_RESULT $? 0 0 "Check GET -E failed"
    GET -d http://www.baidu.com
    CHECK_RESULT $? 0 0 "Check GET -d failed"
    GET -v 2>&1 | grep 'This is lwp-request version'
    CHECK_RESULT $? 0 0 "Check GET -v failed"
    GET -h 2>&1 | grep 'Usage: GET'
    CHECK_RESULT $? 0 0 "Check GET -h failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
