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
    curl https://www.baidu.com --limit-rate 5m
    CHECK_RESULT $? 0 0 "check curl --limit-rate failed"
    curl --list-only https://httpbingo.org/anything
    CHECK_RESULT $? 0 0 "check curl --list-only failed"
    curl --local-port 100-1000 https://httpbingo.org/anything -v 2>&1 | grep "Local port:"
    CHECK_RESULT $? 0 0 "check curl --local-port failed"
    curl -L https://httpbingo.org/anything
    CHECK_RESULT $? 0 0 "check curl -L failed"
    curl --location-trusted -u lujun9972:1233 https://httpbingo.org/anything
    CHECK_RESULT $? 0 0 "check curl --location-trusted failed"
    curl -j -b cookiefile https://httpbingo.org/anything
    CHECK_RESULT $? 0 0 "check curl -j -b failed"
    curl --login-options 'AUTH=*' https://httpbingo.org/anything -v
    CHECK_RESULT $? 0 0 "check curl --login-options failed"
    curl -M
    CHECK_RESULT $? 0 0 "check curl -M failed"
    curl https://www.baidu.com --max-filesize 100 2>&1 | grep "Maximum file size exceeded"
    CHECK_RESULT $? 0 0 "check curl --max-filesize failed"
    curl --max-redirs 3 https://httpbingo.org/anything
    CHECK_RESULT $? 0 0 "check curl --max-redirs failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
