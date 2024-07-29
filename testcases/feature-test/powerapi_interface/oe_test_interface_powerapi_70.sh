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
#@Desc          :   PWR_CPU_GetUsage() test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "powerapi-devel gcc"
    cp common/demo_main.c ./
    gcc -w -g common/test-sort.c -o test-sort
    echo "int main(int argc, const char *args[])
{
    TEST_PWR_Register();
    TEST_PWR_CPU_GetUsage();
    TEST_PWR_UnRegister();
    return 0;
}
" >> demo_main.c
    gcc ./demo_main.c -o demo_main -lpwrapi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ./test-sort &
    CpuNums=$(nproc)
    taskset -cp "$(("${CpuNums}"-1))" "$(pgrep test-sort)"
    ./demo_main > test.log
    GetCoreNum=$(grep "CPU avgUsage: .*, coreNum: .*" test.log | awk -F "coreNum: " '{print $2}')
    GetCoreUsage=$(grep "core.* usage" -c test.log)
    CoreUsageResult=$(grep "core\["$(("${CpuNums}"-1))"\] usage: " test.log | awk -F "usage:" '{print $2}')
    test "${CpuNums}" -eq "${GetCoreNum}" -a "${GetCoreNum}" -eq "${GetCoreUsage}" -a "$(echo "${CoreUsageResult} > 0.000000"|bc)" -eq 1
    CHECK_RESULT $? 0 0 'Check interface TEST_PWR_CPU_GetUsage failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    pgrep test-sort | xargs kill -9 
    rm -rf demo_main* test-sort test.log /root/pwrclient.sock
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
