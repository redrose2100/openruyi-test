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
#@Author        :   wenjun
#@Contact       :   1009065695@qq.com
#@Date          :   2024-03-15
#@License       :   Mulan PSL v2
#@Desc          :   PWR_CPU_GetIdleGovernor() success test
##################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if [ "${NODE1_MACHINE}" != "physical" ]; then
        LOG_INFO "The environment does not support testing"
        exit 0
    fi
    DNF_INSTALL "powerapi-devel gcc"
    cp common/demo_main.c ./
    echo "int main(int argc, const char *args[])
{
    TEST_PWR_SetLogCallback();
    TEST_PWR_Register();
    TEST_PWR_CPU_GetIdleGovernor();
    TEST_PWR_UnRegister();
    return 0;
}
" >> demo_main.c
    gcc ./demo_main.c -o demo_main -lpwrapi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ./demo_main > test.log
    if test -d /sys/devices/system/cpu/cpu0/cpuidle; then
        grep "PWR_CPU_GetIdleGovernor.*SUCCESS ret: 0" test.log
    else
        grep "PWR_CPU_GetIdleGovernor.*ERROR   ret: 15" test.log
    fi
    CHECK_RESULT $? 0 0 "Check interface PWR_CPU_GetIdleGovernor failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf demo_main* pwrclient.sock test.log
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
