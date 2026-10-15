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
    curl --happy-eyeballs-timeout-ms 100 https://httpbingo.org/anything
    CHECK_RESULT $? 0 0 "check curl --happy-eyeballs-timeout-ms failed"
    curl -I https://www.baidu.com | grep "Content-Type"
    CHECK_RESULT $? 0 0 "check curl -I failed"
    curl -H "User-Agent: elephant" 'https://httpbingo.org/anything' 2>&1 | grep "elephant"
    CHECK_RESULT $? 0 0 "check curl -H failed"
    curl -h 2>&1 | grep "curl"
    CHECK_RESULT $? 0 0 "check curl -h failed"
    curl --hostpubmd5 e5c1c49020640a5ab0f2034854c321a8 https://httpbingo.org/anything
    CHECK_RESULT $? 0 0 "check curl --hostpubmd5 failed"
    curl --http0.9 https://httpbingo.org/anything
    CHECK_RESULT $? 0 0 "check curl --http0.9 failed"
    curl -0 http://www.baidu.com -v 2>&1 | grep "HTTP 1.0"
    CHECK_RESULT $? 0 0 "check curl -0failed"
    curl --http1.1 http://www.baidu.com -v 2>&1 | grep "HTTP/1.1"
    CHECK_RESULT $? 0 0 "check curl --http1.1 failed"
    curl --http2 https://httpbingo.org/anything -v 2>&1 | grep "HTTP/2 200"
    CHECK_RESULT $? 0 0 "check curl --http2 failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
