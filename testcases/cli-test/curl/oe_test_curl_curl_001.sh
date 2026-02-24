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
    curl --anyauth -u root:pass http://www.baidu.com
    CHECK_RESULT $? 0 0 "check curl --anyauth  failed"
    curl -a https://httpbingo.org/anything
    CHECK_RESULT $? 0 0 "check curl -a failed"
    curl --basic https://httpbingo.org/anything
    CHECK_RESULT $? 0 0 "check curl --basic failed"
    curl --cacert /etc/pki/tls/certs/ca-bundle.crt https://httpbingo.org/anything
    CHECK_RESULT $? 0 0 "check curl --cacert failed"
    curl --capath /etc/pki/tls/certs/ https://httpbingo.org/
    CHECK_RESULT $? 0 0 "check curl --capath failed"
    curl --connect-timeout 10 https://httpbingo.org/anything
    CHECK_RESULT $? 0 0 "check curl --connect-timeoutfailed"
    curl -C - https://www.baidu.com
    CHECK_RESULT $? 0 0 "check curl -C failed"
    curl https://www.baidu.com --cookie "user=root;pass=123456" -v 2>&1 | grep "Set-Cookie"
    CHECK_RESULT $? 0 0 "check curl https://www.baidu.com failed"
    curl https://www.baidu.com -c cookiefile && test -f cookiefile
    CHECK_RESULT $? 0 0 "check curl -c failed"
    curl --create-dirs https://httpbingo.org/anything
    CHECK_RESULT $? 0 0 "check curl --create-dirs failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf cookiefile
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
