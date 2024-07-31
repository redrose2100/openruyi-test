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
#@Desc          :   PWR_PROC_GetWattAttrs() and PWR_PROC_SetWattAttrs() test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if [ "${NODE1_FRAME}" != "aarch64" ]; then
        LOG_INFO "The environment does not support testing"
        exit 0
    fi
    DNF_INSTALL "powerapi-devel gcc numactl"
    cp common/demo_main.c ./
    ((DMask=2**$(numactl --hardware | grep available: | awk -F " " '{print $2}'))) || true
    echo "int main(int argc, const char *args[])
{
    TEST_PWR_Register();
    PWR_RequestControlAuth();
    TEST_PWR_PROC_SetAndGetWattAttrs(0, 0, 0);
    TEST_PWR_PROC_SetAndGetWattAttrs(100, 3600000, $((DMask-1)));
    TEST_PWR_PROC_SetAndGetWattAttrs(-1, -1, $((DMask-1)));
    TEST_PWR_PROC_SetAndGetWattAttrs(101, 3600001, $((DMask-1)));
    TEST_PWR_PROC_SetAndGetWattAttrs(0, 0, 1);
    TEST_PWR_PROC_SetAndGetWattAttrs(0, 0, ${DMask});
    TEST_PWR_PROC_SetAndGetWattAttrs(85, 2000, 15);
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
    test "$(grep "PWR_PROC_GetWattAttrs" test.log | head -n 1)" == "$(grep "PWR_PROC_GetWattAttrs" test.log | head -n 2 | tail -n 1)"
    CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattAttrs all param are set to 0 failed"
    grep "After PWR_PROC_SetWattAttrs: ret:0 th:100, interval:3600000 dmask:$((DMask-1))" test.log
    CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattAttrs param are 100, 3600000, $((DMask-1)) failed"    
    test "$(grep "After PWR_PROC_SetWattAttrs: ret:6 th:100, interval:3600000 dmask:$((DMask-1))" -c test.log)" -eq 2
    CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattAttrs param are -1, -1, $((DMask-1)) or 101, 3600001, $((DMask-1)) failed"
    grep "After PWR_PROC_SetWattAttrs: ret:0 th:100, interval:3600000 dmask:1" test.log
    CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattAttrs param are 0, 0, 1 failed"
    grep "PWR_PROC_SetWattAttrs. ret: 502" test.log
    CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattAttrs param are 0, 0, ${DMask} failed"
    test "$(grep "After PWR_PROC_SetWattAttrs" test.log | tail -n 1)" == "After PWR_PROC_SetWattAttrs: ret:0 th:85, interval:2000 dmask:15"
    CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattAttrs all param are set to default values failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf demo_main* test.log /root/pwrclient.sock
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
