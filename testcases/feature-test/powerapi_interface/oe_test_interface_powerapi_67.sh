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
#@Date          :   2024-08-17
#@License       :   Mulan PSL v2
#@Desc          :   normal user PWR_SYS_SetPowerState() state -1 test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "powerapi-devel gcc"
    cp common/demo_main.c ./
    echo "int main(int argc, const char *args[])
{
    TEST_PWR_Register();
    PWR_RequestControlAuth();
    TEST_SYS_SetPowerState(-1);
    PWR_ReleaseControlAuth();
    TEST_PWR_UnRegister();
    return 0;
}
" >> demo_main.c
    gcc ./demo_main.c -o demo_main -lpwrapi
    useradd test1
    cp demo_main /home/test1
    sed -i "s/admin=root/admin=test1/g" /etc/sysconfig/pwrapis/pwrapis_config.ini
    SLEEP_WAIT 5
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    su - test1 -c "./demo_main" | grep "PWR_SYS_SetPowerState ret: 6"
    CHECK_RESULT $? 0 0 "Check interface PWR_SYS_SetPowerState() state -1 failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    userdel -r test1
    rm -rf demo_main*
    sed -i "s/admin=test1/admin=root/g" /etc/sysconfig/pwrapis/pwrapis_config.ini
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"

