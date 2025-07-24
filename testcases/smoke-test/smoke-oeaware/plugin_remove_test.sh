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
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if yum list oeAware-manager; then
        DNF_INSTALL "oeAware-manager"
    else
        echo "oeAware-manager does not exist"
        exit 255
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    test1=$(oeawarectl -r test.so)
    CHECK_RESULT "$test1" "Plugin remove failed, because plugin does not exist." 0 "test1 failed"
    test2=$(oeawarectl -r libsystem_collector.so)
    CHECK_RESULT "$test2" "Plugin remove successfully." 0 "test2 failed"
    test3=$(oeawarectl -r libsystem_tune.so)
    CHECK_RESULT "$test3" "Plugin remove successfully." 0 "test3 failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
