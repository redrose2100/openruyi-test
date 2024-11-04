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
    oeawarectl -r libthread_tune.so | grep "Plugin remove successfully"
    CHECK_RESULT $? 0 0 "Failed command: oeawarectl -r|--remove"
    oeawarectl -r libthread_scenario.so | grep "Plugin remove successfully"
    CHECK_RESULT $? 0 0 "Failed command: oeawarectl -r|--remove"
    oeawarectl -l libthread_scenario.so | grep "Plugin loaded successfully"
    CHECK_RESULT $? 0 0 "Failed command: oeawarectl -l|--load"
    oeawarectl -l libthread_scenario.so | grep "Plugin loaded failed, because plugin already loaded"
    CHECK_RESULT $? 0 0 "Plugin loaded error"

    oeawarectl -l test.so | grep "Plugin loaded failed, because plugin file does not exist"
    CHECK_RESULT $? 0 0 "Plugin loaded error"

    oeawarectl --query test.so | grep "Plugin query failed, because plugin does not exist"
    CHECK_RESULT $? 0 0 "Plugin query error"

    oeawarectl -e test | grep "Instance enabled failed, because instance is not loaded"
    CHECK_RESULT $? 0 0 "Instance enabled error"

    oeawarectl -d test | grep "Instance disabled failed, because instance is not loaded"
    CHECK_RESULT $? 0 0 "Instance disabled error"

    oeawarectl -i test | grep "Download failed, because unable to find a match: test"
    CHECK_RESULT $? 0 0 "Instance Download error"

    oeawarectl 2>&1 | grep "option error"
    CHECK_RESULT $? 0 0 "command error"

    oeawarectl -m 2>&1 | grep "unknown option"
    CHECK_RESULT $? 0 0 "command error"
    oeawarectl -? 2>&1 | grep "unknown option"
    CHECK_RESULT $? 0 0 "command error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
