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
    lwp-request -m GET http://www.baidu.com 2>&1 | grep 'Content-Type'
    CHECK_RESULT $? 0 0 "Check lwp-request -m failed"
    lwp-request -f GET http://www.baidu.com 2>&1 | grep 'Content-Type'
    CHECK_RESULT $? 0 0 "Check lwp-request -f failed"
    lwp-request -b http://www.baidu.com http://www.baidu.com 2>&1 | grep 'http-equiv'
    CHECK_RESULT $? 0 0 "Check lwp-request -b failed"
    lwp-request -t 10 http://www.baidu.com 2>&1 | grep 'STATUS'
    CHECK_RESULT $? 0 0 "Check lwp-request -t failed"
    lwp-request -i $(date "+%Y-%m-%d %H:%M:%S") http://www.baidu.com 2>&1 | grep 'STATUS'
    CHECK_RESULT $? 0 0 "Check lwp-request -i failed"
    lwp-request -a http://www.baidu.com http://www.baidu.com 2>&1 | grep 'http-equiv'
    CHECK_RESULT $? 0 0 "Check lwp-request -a failed"
    lwp-request -p http://www.baidu.com http://www.baidu.com
    CHECK_RESULT $? 0 0 "Check lwp-request -p failed"
    lwp-request -P http://www.baidu.com 2>&1 | grep 'content'
    CHECK_RESULT $? 0 0 "Check lwp-request -P failed"
    lwp-request -C root:123456 http://www.baidu.com 2>&1 | grep 'http-equiv'
    CHECK_RESULT $? 0 0 "Check lwp-request -C   failed"
    lwp-request -u http://www.baidu.com 2>&1 | grep 'GET http://www.baidu.com'
    CHECK_RESULT $? 0 0 "Check lwp-request -u failed"
    lwp-request -U http://www.baidu.com 2>&1 | grep 'User-Agent'
    CHECK_RESULT $? 0 0 "Check lwp-request -u failed"
    LOG_INFO "End to run  test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
