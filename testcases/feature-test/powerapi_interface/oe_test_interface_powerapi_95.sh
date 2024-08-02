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
#@Desc          :   general user PWR_PROC_SetWattFirstDomain() and PWR_PROC_SetWattState(1) test
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
    useradd test1
    sed -i "s/admin=root/admin=test1/g" /etc/sysconfig/pwrapis/pwrapis_config.ini
    echo "int main(int argc, const char *args[])
{
    TEST_PWR_Register();
    PWR_RequestControlAuth();
    TEST_PWR_PROC_SetAndGetWattState_1(1);
    TEST_PWR_PROC_RebuildAffinityDomain();
    PWR_ReleaseControlAuth();
    TEST_PWR_UnRegister();
    return 0;
}
" >> demo_main.c
    gcc ./demo_main.c -o demo_main -lpwrapi
    cp demo_main /home/test1/
    cp common/demo_main.c ./
    echo "int main(int argc, const char *args[])
{
    TEST_PWR_Register();
    PWR_RequestControlAuth();
    TEST_PWR_PROC_SetAndGetWattState_1(1);
    TEST_PWR_PROC_RebuildAffinityDomain_1();
    PWR_ReleaseControlAuth();
    TEST_PWR_UnRegister();
    return 0;
}
" >> demo_main.c
    gcc ./demo_main.c -o demo_main1 -lpwrapi
    cp demo_main1 /home/test1/
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    SLEEP_WAIT 5
    su - test1 -c "./demo_main" > test.log
    grep "SetWattFirstDomain failed. ret:110" test.log
    CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_RebuildAffinityDomain is Online failed"
    grep "PWR_PROC_SetWattFirstDomain: ret:6" test.log
    CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_RebuildAffinityDomain is notExist failed"
    echo 0 > /sys/devices/system/cpu/cpu1/online
    su - test1 -c "./demo_main1" > test.log
    grep "PWR_PROC_SetWattFirstDomain: ret:6" test.log
    CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_RebuildAffinityDomain is Offline failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    echo 1 > /sys/devices/system/cpu/cpu1/online
    rm -rf demo_main* test.log
    sed -i "s/admin=test1/admin=root/g" /etc/sysconfig/pwrapis/pwrapis_config.ini
    SLEEP_WAIT 5
    userdel -r test1
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
