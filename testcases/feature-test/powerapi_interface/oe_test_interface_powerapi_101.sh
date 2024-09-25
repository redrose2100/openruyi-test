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
#@Author        :   erin_dan
#@Contact       :   1743994506@qq.com
#@Date          :   2024-07-10
#@License       :   Mulan PSL v2
#@Desc          :   TEST_PWR_PROC_SetAndGetSmartGridState() test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if [ "${NODE1_FRAME}" != "aarch64" ]; then
        LOG_INFO "The environment does not support testing"
        exit 0
    fi
    DNF_INSTALL "powerapi-devel gcc"
    cp common/demo_main.c ./
    echo "int main(int argc, const char *args[])
{
    TEST_PWR_Register();
    PWR_RequestControlAuth();
    TEST_PWR_PROC_SetAndGetSmartGridState();
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
    ./demo_main > test.log
    < test.log head -n 10 | grep "PWR_PROC_GetSmartGridState. ret: 0 state:0"
    CHECK_RESULT $? 0 0 "Check interface PWR_PROC_GetSmartGridState failed"
    grep -A4 "SetSmartGridState succeed." test.log | grep "PWR_PROC_GetSmartGridState. ret: 0 state:1"
    CHECK_RESULT $? 0 0 "Check interface PWR_PROC_SetSmartGridState(PWR_ENABLE) failed"
    grep -A4 "SetSmartGridState succeed." test.log | grep "PWR_PROC_GetSmartGridState. ret: 0 state:0"
    CHECK_RESULT $? 0 0 "Check interface PWR_PROC_SetSmartGridState(PWR_DISABLE) failed"
    grep "PWR_PROC_SetSmartGridState. ret: 6" test.log
    CHECK_RESULT $? 0 0 "Check interface PWR_PROC_SetSmartGridState(-1) failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf demo_main* test.log /root/pwrclient.sock
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
