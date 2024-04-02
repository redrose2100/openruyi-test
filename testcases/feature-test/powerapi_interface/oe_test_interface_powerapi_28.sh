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
#@Desc          :   PWR_CPU_SetFreqRange() [min+1, max-1] test
##################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if [ "${NODE1_MACHINE}" != "physical" ]; then
        LOG_INFO "The environment does not support testing"
        exit 0
    fi
    DNF_INSTALL "powerapi-devel gcc"
    systemctl stop tuned
    cp common/demo_main.c ./
    echo "int main(int argc, const char *args[])
{
    TEST_PWR_SetLogCallback();
    TEST_PWR_Register();
    PWR_RequestControlAuth();
    TEST_PWR_CPU_SetFreqRange_3();
    PWR_ReleaseControlAuth();
    TEST_PWR_UnRegister();
    return 0;
}
" >> demo_main.c
    gcc ./demo_main.c -o demo_main -lpwrapi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ./demo_main | grep "PWR_CPU_SetFreqRange.*SUCCESS ret: 0"
    CHECK_RESULT $? 0 0 "Check interface PWR_CPU_SetFreqRange failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf demo_main* pwrclient.sock
    systemctl start tuned
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
