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
    lwp-request -s http://www.baidu.com 2>&1 | grep '200 OK'
    CHECK_RESULT $? 0 0 "Check lwp-request -s failed"
    lwp-request -S http://www.baidu.com 2>&1 | grep 'http://www.baidu.com'
    CHECK_RESULT $? 0 0 "Check lwp-request -S failed"
    lwp-request -e http://www.baidu.com 2>&1 | grep '200 OK'
    CHECK_RESULT $? 0 0 "Check lwp-request -e failed"
    lwp-request -E http://www.baidu.com 2>&1 | grep 'User-Agent'
    CHECK_RESULT $? 0 0 "Check lwp-request -E failed"
    lwp-request -d http://www.baidu.com
    CHECK_RESULT $? 0 0 "Check lwp-request -d failed"
    lwp-request -v 2>&1 | grep 'This is lwp-request version'
    CHECK_RESULT $? 0 0 "Check lwp-request -v failed"
    lwp-request -h 2>&1 | grep 'Usage: lwp-request'
    CHECK_RESULT $? 0 0 "Check lwp-request -h failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to  restore the test environment."
}

main $@
