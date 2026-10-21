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
#@Desc          :   SYS_GetRtPowerInfo() test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if [[ "${NODE1_FRAME}" != "x86_64" && "${NODE1_FRAME}" != "aarch64" ]]; then
        LOG_WARN "Current architecture (${NODE1_FRAME}) is not supported by powerapi, skipping test."
        exit 255
    fi
    DNF_INSTALL "powerapi-devel gcc ipmitool"
    cp common/demo_main.c ./
    echo "int main(int argc, const char *args[])
{
    TEST_PWR_Register();
    TEST_SYS_GetRtPowerInfo();
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
    test "$(grep "sys rt power:" test.log | awk -F ":" '{print $2}')" -gt 0
    CHECK_RESULT $? 0 0 "Check interface TEST_SYS_GetRtPowerInfo about sysPower failed"
    if [[ "${NODE1_FRAME}" == "x86_64" ]]; then
	test "$(grep "cpu rt power:" test.log | awk -F ":" '{print $2}')" -gt 0
        CHECK_RESULT $? 0 0 "Check interface TEST_SYS_GetRtPowerInfo about cpuPower failed"
	test "$(grep "mem rt power:" test.log | awk -F ":" '{print $2}')" -gt 0
        CHECK_RESULT $? 0 0 "Check interface TEST_SYS_GetRtPowerInfo about memPower failed"
    else
	test "$(grep "cpu rt power:" test.log | awk -F ":" '{print $2}')" -eq 0
	CHECK_RESULT $? 0 0 "Check interface TEST_SYS_GetRtPowerInfo about cpuPower failed"
	test "$(grep "mem rt power:" test.log | awk -F ":" '{print $2}')" -eq 0
	CHECK_RESULT $? 0 0 "Check interface TEST_SYS_GetRtPowerInfo about memPower failed"
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
