#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
###################################
#@Author        :   wangshan
#@Contact       :   906259653@qq.com
#@Date          :   2023/7/12
#@License       :   Mulan PSL v2
#@Desc          :   Test curl command
###################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "curl"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    curl --http2-prior-knowledge https://httpbingo.org/anything -v 2>&1 | grep "HTTP/2 200"
    CHECK_RESULT $? 0 0 "check curl --http2-prior-knowledge failed"
    curl --ignore-content-length https://httpbingo.org/anything
    CHECK_RESULT $? 0 0 "check curl --ignore-content-length failed"
    curl -i https://www.baidu.com | grep "Content-Type"
    CHECK_RESULT $? 0 0 "check curl -i failed"
    curl -k 'https://httpbingo.org/anything'
    CHECK_RESULT $? 0 0 "check curl -k failed"
    curl --interface "${NODE1_NIC}" https://httpbingo.org/anything
    CHECK_RESULT $? 0 0 "check curl --interfacefailed"
    curl -4 http://www.baidu.com
    CHECK_RESULT $? 0 0 "check curl -4 failed"
    curl --key here https://httpbingo.org/anything
    CHECK_RESULT $? 0 0 "check curl --key failed"
    curl --key-type DER --key here https://httpbingo.org/anything
    CHECK_RESULT $? 0 0 "check curl --key-type failed"
    curl --libcurl client.c https://httpbingo.org/anything && test -f client.c
    CHECK_RESULT $? 0 0 "check curl --libcurl failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
