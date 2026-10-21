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
#    curl --metalink "https://httpbingo.org/anything"
#    CHECK_RESULT $? 0 0 "check curl --metalink failed"
    curl --negotiate "https://httpbingo.org/anything"
    CHECK_RESULT $? 0 0 "check curl --negotiate failed"
    curl https://www.baidu.com -o output.txt && test -f output.txt
    CHECK_RESULT $? 0 0 "check curl -o failed"
    curl -# http://www.baidu.com/
    CHECK_RESULT $? 0 0 "check curl -# failed"
    curl --referer https://www.baidu.com https://www.baidu.com
    CHECK_RESULT $? 0 0 "check curl --referer failed"
    curl --silent -O https://www.cnblogs.com/kevingrace/p/9030324.html && test -f 9030324.html
    CHECK_RESULT $? 0 0 "check curl --silent -O failed"
    curl -X POST "https://httpbingo.org/anything" -H "accept: application/json"
    CHECK_RESULT $? 0 0 "check curl -X failed"
    curl -1 http://www.baidu.com
    CHECK_RESULT $? 0 0 "check curl -1 failed"
    curl --tlsv1.0 http://www.baidu.com
    CHECK_RESULT $? 0 0 "check curl --tlsv1.0 failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf output.txt 9030324.html
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
