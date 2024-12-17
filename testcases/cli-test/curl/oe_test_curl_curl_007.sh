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
    vers=$(rpm -qa | grep "^curl" | awk -F - '{print $2}')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    curl --tlsv1.1 http://www.baidu.com
    CHECK_RESULT $? 0 0 "check curl --tlsv1.1 failed"
    curl --tlsv1.2 http://www.baidu.com
    CHECK_RESULT $? 0 0 "check curl --tlsv1.2 failed"
    curl --tlsv1.3 http://www.baidu.com
    CHECK_RESULT $? 0 0 "check curl --tlsv1.3 failed"
    curl https://www.baidu.com -A "Mozilla/5.0"
    CHECK_RESULT $? 0 0 "check curl -A failed"
    curl -v https://www.sina.com.cn
    CHECK_RESULT $? 0 0 "check curl -v failed"
    curl -V | grep "$vers"
    CHECK_RESULT $? 0 0 "check curl -V failed"
    curl -w '{
        > "time_namelookup": %{time_namelookup},
        > "time_connect": %{time_connect},
        > "local_ip": "%{local_ip}",
        > "local_port": "%{local_port}"
        > }' http://www.baidu.com 2>&1 | grep "time_namelookup"
    CHECK_RESULT $? 0 0 "check curl -w failed"
    curl --trace output1.txt https://www.sina.com.cn && test -f output1.txt
    CHECK_RESULT $? 0 0 "check curl --trace failed"
    curl --trace-ascii output2.txt https://www.sina.com.cn && test -f output2.txt
    CHECK_RESULT $? 0 0 "check curl --trace-ascii failed"
    currentTime=$(date "+%H:%M")
    curl --trace-time --trace output3.txt https://www.baidu.com && grep "$currentTime" output3.txt
    CHECK_RESULT $? 0 0 "check curl --trace-time --trace failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf output*
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
