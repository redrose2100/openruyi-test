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
#@Desc          :   PWR_PROC_GetSmartGridGov() and PWR_PROC_SetSmartGridGov() test
#####################################

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
    TEST_PWR_Register();
    PWR_RequestControlAuth();
    TEST_PWR_PROC_SetAndGetSmartGridGov();
    TEST_PWR_PROC_SetAndGetSmartGridGov_1(1, \"performance\", \"conservative\");
    TEST_PWR_PROC_SetAndGetSmartGridGov_1(1, \"bbb\", \"aaa\");
    TEST_PWR_PROC_SetAndGetSmartGridGov_1(1, \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\");
    TEST_PWR_PROC_SetAndGetSmartGridGov_1(1, \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\", \"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\");
    TEST_PWR_PROC_SetAndGetSmartGridGov_1(0, \"ondemand\", \"userspace\");
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
    if [[ $(uname -m) == "aarch64" ]]; then
            grep "PWR_PROC_GetSmartGridGov: ret:0 sgAgentState:0, sgLevel0Gov: sgLevel1Gov:" test.log
            CHECK_RESULT $? 0 0 "Check interface PWR_PROC_GetSmartGridGov() failed"
            grep -A4 "SetSmartGridGov succeed." test.log | grep "PWR_PROC_GetSmartGridGov: after set. ret:0 sgAgentState:1, sgLevel0Gov:performance sgLevel1Gov:conservative"
            CHECK_RESULT $? 0 0 "Check interface PWR_PROC_SetSmartGridGov(1, \"performance\", \"conservative\") failed"
            if [[ "$(grep "SetSmartGridGov failed. ret:502" -c test.log)" -eq 2 ]]; then
	           CHECK_RESULT $? 0 0 "Check interface PWR_PROC_SetSmartGridGov() params about sgAgentState,level0Gov,level1Gov:1,not exist or 1,the length is 31 failed"
            fi
            grep "Send req failed. optType: 613, ret: 2" test.log
            CHECK_RESULT $? 0 0 "Check interface PWR_PROC_SetSmartGridGov() params about sgAgentState,level0Gov,level1Gov:1, the length is 32 failed"
            grep -A4 "SetSmartGridGov succeed" test.log | grep "PWR_PROC_GetSmartGridGov: after set. ret:0 sgAgentState:0, sgLevel0Gov: sgLevel1Gov:"
            CHECK_RESULT $? 0 0 "Check interface PWR_PROC_SetSmartGridGov(0, \"ondemand\", \"userspace\") failed"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf demo_main* test.log /root/pwrclient.sock
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
