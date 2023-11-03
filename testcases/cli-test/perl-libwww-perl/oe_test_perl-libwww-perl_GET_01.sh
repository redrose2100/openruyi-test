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
    DNF_INSTALL "perl-libwww-perl perl-CPAN"
    tar -xf common/HTML-Tree-5.07.tar.gz
    cd HTML-Tree-5.07
    perl Build.PL
    ./Build
    ./Build test
    ./Build install
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    GET -m 'GET' http://www.baidu.com 2>&1 | grep 'head'
    CHECK_RESULT $? 0 0 "Check GET -m  failed"
    GET -f http://www.baidu.com 2>&1 | grep 'DOCTYPE html'
    CHECK_RESULT $? 0 0 "Check GET -f  failed"
    GET -b www.baidu.com http://www.baidu.com 2>&1 | grep 'DOCTYPE html'
    CHECK_RESULT $? 0 0 "Check GET -b  failed"
    GET -t 10 http://www.baidu.com 2>&1 | grep 'DOCTYPE html'
    CHECK_RESULT $? 0 0 "Check GET  -t failed"
    GET -i "$(date +"%F %T")" http://www.baidu.com 2>&1 | grep 'DOCTYPE html'
    CHECK_RESULT $? 0 0 "Check GET -i failed"
    GET -a http://www.baidu.com 2>&1 | grep 'DOCTYPE html'
    CHECK_RESULT $? 0 0 "Check GET  -a failed"
    GET -p http://www.baidu.com http://www.baidu.com
    CHECK_RESULT $? 0 0 "Check GET -p  failed"
    GET -P http://www.baidu.com 2>&1 | grep 'DOCTYPE html'
    CHECK_RESULT $? 0 0 "Check GET -P  failed"
    GET -H Content-Type: text/plain http://www.baidu.com 2>&1 | grep 'DOCTYPE html'
    CHECK_RESULT $? 0 0 "Check GET -H  failed"
    GET -C root:123456 http://www.baidu.com 2>&1 | grep 'DOCTYPE html'
    CHECK_RESULT $? 0 0 "Check GET -C failed"
    GET -o html www.baidu.com | grep 'content'
    CHECK_RESULT $? 0 0 "Check GET -o failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    cd ..
    rm -rf HTML-Tree-5.07
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
