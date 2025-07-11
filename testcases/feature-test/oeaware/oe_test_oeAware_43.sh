#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   wenjun
#@Contact       :   1009065695@qq.com
#@Date          :   2025-03-25
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/testcases/feature-test/oeaware/common/common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    pre_nginx
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    oeawarectl -e preload_tune | grep "Instance enabled successfully" && oeawarectl -q | grep "preload_tune(available, running, count: 1)"
    CHECK_RESULT $? 0 0 "Error: Check preload_tune enable failed"
    ldd /usr/sbin/nginx | grep "libsmc-preload.so" && ldd /usr/bin/wrk | grep "libsmc-preload.so"
    CHECK_RESULT $? 0 0 "Error: Check preload_tune enable failed"
    oeawarectl -d preload_tune | grep "Instance disabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check preload_tune disable failed"
    oeawarectl -q | grep "preload_tune(available, close, count: 1)"
    CHECK_RESULT $? 0 0 "Error: Check preload_tune disable failed"
    ldd /usr/sbin/nginx | grep "libsmc-preload.so" && ldd /usr/bin/wrk | grep "libsmc-preload.so"
    CHECK_RESULT $? 1 0 "Error: Check preload_tune disable failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    post_nginx "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
