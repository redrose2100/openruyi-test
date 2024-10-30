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
#@Date          :   2024-06-06
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "oeAware-manager"
    systemctl daemon-reload
    systemctl start oeaware
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    oeawarectl --query libthread_collector.so | grep "Show plugins and instances status"
    CHECK_RESULT $? 0 0 "query plugin failed"
    oeawarectl --query libthread_scenario.so | grep "Show plugins and instances status"
    CHECK_RESULT $? 0 0 "query plugin failed"
    if [ "$NODE1_FRAME" == "aarch64" ]; then
        oeawarectl --query libpmu.so | grep "Show plugins and instances status"
        CHECK_RESULT $? 0 0 "query plugin failed"
    fi
    oeawarectl -Q | grep "Generate dependencies graph dep.png"
    CHECK_RESULT $? 0 0 "Failed command: oeawarectl -Q"

    oeawarectl --query-dep thread_scenario | grep "Generate dependencies graph dep.png"
    CHECK_RESULT $? 0 0 "Failed command: oeawarectl --query-dep"

    oeawarectl -r libthread_tune.so | grep "Plugin remove successfully"
    CHECK_RESULT $? 0 0 "Failed command: oeawarectl -r|--remove"

    oeawarectl -r libthread_scenario.so | grep "Plugin remove successfully"
    CHECK_RESULT $? 0 0 "Failed command: oeawarectl -r|--remove"
    oeawarectl -q | grep "libthread_scenario.so"
    CHECK_RESULT $? 0 1 "query plugin failed"

    oeawarectl -l libthread_scenario.so | grep "Plugin loaded successfully"
    CHECK_RESULT $? 0 0 "Failed command: oeawarectl -l|--load"
    oeawarectl -q | grep "libthread_scenario.so"
    CHECK_RESULT $? 0 0 "query plugin failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl restart oeaware
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
