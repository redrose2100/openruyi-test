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
    touch /lib64/oeAware-plugin/test
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    test1=$(oeawarectl -l test.so)
    CHECK_RESULT "$test1" "Plugin loaded failed, because plugin file does not exist." 0 "test1 failed"
    test2=$(oeawarectl -l libsystem_collector.so)
    CHECK_RESULT "$test2" "Plugin loaded failed, because plugin already loaded." 0 "test2 failed"
    test3=$(oeawarectl -l test)
    CHECK_RESULT "$test3" "Plugin loaded failed, because file is not a plugin file." 0 "test3 failed"
    test4=$(oeawarectl -r libsystem_tune.so)
    CHECK_RESULT "$test4" "Plugin remove successfully." 0 "test4 failed"
    test5=$(oeawarectl -l libsystem_tune.so)
    CHECK_RESULT "$test5" "Plugin loaded successfully." 0 "test5 failed"
    test6=$(oeawarectl -q | grep libsystem_tune.so)
    CHECK_RESULT "$test6" "libsystem_tune.so" 0 "test6 failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f /lib64/oeAware-plugin/test
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
