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
    curl -X POST "https://httpbin.org/anything" -H "accept: application/json" --data '{"value":"panda"}' 2>&1 | grep "panda"
    CHECK_RESULT $? 0 0 "check curl -X failed"
    curl --dump-header headers http://www.baidu.com && test -f headers
    CHECK_RESULT $? 0 0 "check curl --dump-header failed"
    curl -f https://httpbin.org/anything
    CHECK_RESULT $? 0 0 "check curl -f  failed"
    curl -F name=John -X POST "https://httpbin.org/anything" 2>&1 | grep "John"
    CHECK_RESULT $? 0 0 "check curl -F  failed"
    curl --form-string "name=daniel;type=text/foo" -X POST "https://httpbin.org/anything" 2>&1 | grep "type=text/foo"
    CHECK_RESULT $? 0 0 "check curl --form-string failed"
    curl --ftp-account "mr.robot" -f https://httpbin.org/anything
    CHECK_RESULT $? 0 0 "check curl --ftp-account failed"
    curl --ftp-alternative-to-user "U53r" -f https://httpbin.org/anything
    CHECK_RESULT $? 0 0 "check curl --ftp-alternative-to-user failed"
    curl --get https://httpbin.org/anything
    CHECK_RESULT $? 0 0 "check curl --get failed"
    curl -g https://httpbin.org/anything/{}
    CHECK_RESULT $? 0 0 "check curl -g  failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf headers
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
