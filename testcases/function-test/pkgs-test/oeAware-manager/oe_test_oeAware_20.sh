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
#@Author        :   linqian
#@Contact       :   1179362010@qq.com
#@Date          :   2024-06-15
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
    oeawarectl -r libsystem_collector.so | grep "Plugin remove successfully"
    CHECK_RESULT $? 0 0 "Error: libthread_collector.so plugin remove"
    oeawarectl -e thread_scenario | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: thread_scenario plugin enable"
    oeawarectl -q | grep "thread_scenario(available, running, count: 1)"
    CHECK_RESULT $? 0 0 "Error: thread_scenario enabled failed"
    oeawarectl -l libsystem_collector.so | grep "Plugin loaded successfully"
    CHECK_RESULT $? 0 0 "Error: libthread_collector.so plugin load"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl restart oeaware
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
