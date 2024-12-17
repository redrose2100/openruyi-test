#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   fly_1997
#@Contact       :   flylove7@outlook.com
#@Date          :   2024-08-08
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "oeAware-manager"
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    test1=$(oeawarectl --query test.so)
    CHECK_RESULT "$test1" "Plugin query failed, because plugin does not exist." 0 "test1 failed"
    test2=$(oeawarectl --query libthread_collector.so | grep "libthread_collector.so")
    CHECK_RESULT "$test2" "libthread_collector.so" 0 "test2 failed"
    test2=$(oeawarectl --query libthread_collector.so | grep "thread_collector(available, close)")
    CHECK_RESULT "$test2" "	thread_collector(available, close)" 0 "test2 failed"
    test3=$(oeawarectl -q | grep "libthread_tune.so")
    CHECK_RESULT "$test3" "libthread_tune.so" 0 "test3 failed"
    test3=$(oeawarectl -q | grep "libthread_scenario.so")
    CHECK_RESULT "$test3" "libthread_scenario.so" 0 "test3 failed"
    test3=$(oeawarectl -q | grep "libthread_collector.so")
    CHECK_RESULT "$test3" "libthread_collector.so" 0 "test3 failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
