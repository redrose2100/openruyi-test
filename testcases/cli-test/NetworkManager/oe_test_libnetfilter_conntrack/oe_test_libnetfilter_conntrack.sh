#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   wangxiaorou
#@Contact       :   wangxiaorou@uniontech.com
#@Date          :   2023-03-28
#@License       :   Mulan PSL v2
#@Desc          :   the function of libnetfilter_conntrack
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libnetfilter_conntrack libnetfilter_conntrack-devel libnfnetlink-devel libmnl-devel"
    test -f ./test_api.log && rm -rf ./test_api.log
    test -f ./test_api && rm -rf ./test_api
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    gcc  -o test_api  test_api.c  -I../include /usr/lib64/libnetfilter_conntrack.so.3
    test -f ./test_api
    CHECK_RESULT $? 0 0 "compile test_api"
    ./test_api 2>&1 > test_api.log
    CHECK_RESULT $? 0 0 "test_api run"
    CHECK_RESULT "$(cat test_api.log |grep -v ^== |grep -v OK |wc -l)" "0" 0 "check log of test_api"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    test -f ./test_api.log && rm -rf ./test_api.log
    test -f ./test_api && rm -rf ./test_api
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"

