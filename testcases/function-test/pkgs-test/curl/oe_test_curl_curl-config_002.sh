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
    DNF_INSTALL "curl libcurl-devel"
    vers=$(rpm -qa | grep libcurl-devel | awk -F - '{print $3}')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    curl-config --protocols
    CHECK_RESULT $? 0 0 "check bcurl-config --protocols failed"
    curl-config --ssl-backends | grep "OpenSSL"
    CHECK_RESULT $? 0 0 "check curl-config --ssl-backends failed"
    curl-config --version | grep "${vers}"
    CHECK_RESULT $? 0 0 "check curl-config --version failed"
    curl-config --vernum
    CHECK_RESULT $? 0 0 "check curl-config --vernum failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
