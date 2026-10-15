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
    vers=$(rpm -qa | grep "libcurl-devel" | awk -F - '{print $3}')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    curl-config --built-shared | grep "yes"
    CHECK_RESULT $? 0 0 "check bnd curl-config --built-shared failed"
    curl-config --ca | grep "ca-bundle.crt"
    CHECK_RESULT $? 0 0 "check curl-config --ca failed"
    curl-config --cc | grep "gcc"
    CHECK_RESULT $? 0 0 "check curl-config --cc failed"
    curl-config --cflags
    CHECK_RESULT $? 0 0 "check curl-config --cflags failed"
    curl-config --checkfor "${vers}"
    CHECK_RESULT $? 0 0 "check curl-config --checkfor failed"
    curl-config --configure 
    CHECK_RESULT $? 0 0 "check curl-config --configure failed"
    curl-config --features
    CHECK_RESULT $? 0 0 "check curl-config --features failed"
    curl-config -h 2>&1 | grep "curl-config"
    CHECK_RESULT $? 0 0 "check curl-config -h failed"
    curl-config --libs 
    CHECK_RESULT $? 0 0 "check curl-config --libs failed"
    curl-config --prefix | grep "/usr"
    CHECK_RESULT $? 0 0 "check curl-config --prefix failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
