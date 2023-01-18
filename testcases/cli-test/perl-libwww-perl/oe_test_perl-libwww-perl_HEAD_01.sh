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
    HEAD -m 'GET' http://www.baidu.com 2>&1 | grep '<head>'
    CHECK_RESULT $? 0 0 "Check HEAD -m failed"
    HEAD -f http://www.baidu.com 2>&1 | grep 'Accept-Ranges:'
    CHECK_RESULT $? 0 0 "Check HEAD -f failed"
    HEAD -b http://www.baidu.com http://www.baidu.com 2>&1 | grep 'Cache-Control:'
    CHECK_RESULT $? 0 0 "Check HEAD -b failed"
    HEAD -t 10 http://www.baidu.com 2>&1 | grep 'Cache-Control:'
    CHECK_RESULT $? 0 0 "Check HEAD -t failed"
    HEAD -i $(date "+%Y-%m-%d %H:%M:%S") http://www.baidu.com 2>&1 | grep 'Client-Date'
    CHECK_RESULT $? 0 0 "Check HEAD -i failed"
    HEAD -a http://www.baidu.com 2>&1 | grep 'Content-Type: text'
    CHECK_RESULT $? 0 0 "Check HEAD -a failed"
    HEAD -p http://www.baidu.com http://www.baidu.com 2>&1 | grep 'Apache'
    CHECK_RESULT $? 0 0 "Check HEAD -p  failed"
    HEAD -P http://www.baidu.com 2>&1 | grep 'Cache-Control: private'
    CHECK_RESULT $? 0 0 "Check HEAD -P failed"
    HEAD -C root:123456 http://www.baidu.com 2>&1 | grep 'Client-Response-Num:'
    CHECK_RESULT $? 0 0 "Check HEAD -C failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
