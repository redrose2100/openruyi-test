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
    test1=$(oeawarectl -e thread_collector)
    CHECK_RESULT "$test1" "Instance enabled successfully." 0 "test1 failed"
    test2=$(oeawarectl -e thread_collector)
    CHECK_RESULT "$test2" "Instance enabled failed, because instance is already enabled." 0 "test2 failed"
    test3=$(oeawarectl -e test)
    CHECK_RESULT "$test3" "Instance enabled failed, because instance is not loaded." 0 "test3 failed"
    test4=$(oeawarectl -e thread_tune)
    CHECK_RESULT "$test4" "Instance enabled successfully." 0 "test4 failed"
    systemctl stop oeaware
    rm -f /lib64/oeAware-plugin/libthread_collector.so
    systemctl start oeaware
    sleep 1
    test5=$(oeawarectl -e thread_tune)
    CHECK_RESULT "$test5" "Instance enabled failed, because instance is unavailable." 0 "test5 failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
