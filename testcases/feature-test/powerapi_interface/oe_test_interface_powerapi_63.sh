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
#@Desc          :   SetEventCallback() test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "powerapi-devel gcc"
    echo "" > /var/log/pwrapis/papis.log
    useradd eagle
    sed -i "s/admin=root/admin=root,eagle/g" /etc/sysconfig/pwrapis/pwrapis_config.ini
    cp common/demo_main.c ./
    echo "int main(int argc, const char *args[])
{
    TEST_PWR_Register();
    TEST_PWR_SetEventCallback_2();
    TEST_PWR_UnRegister();
    return 0;
}
" >> demo_main.c
    gcc ./demo_main.c -o demo_main -lpwrapi
    cp demo_main /home/eagle/
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    SLEEP_WAIT 5
    su - eagle -c "./demo_main" > test.log &
    SLEEP_WAIT 5
    ./demo_main >> test.log
    grep -A2 "Get event notification" test.log | grep "Not authorized"
    CHECK_RESULT $? 0 0 "Check interface TEST_PWR_SetEventCallback failed"
    grep "Auth owned by .* force released by root" /var/log/pwrapis/papis.log 
    CHECK_RESULT $? 0 0 "Check interface TEST_PWR_SetEventCallback about papis.log info failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf demo_main* test.log /root/pwrclient.sock
    sed -i "s/admin=root,eagle/admin=root/g" /etc/sysconfig/pwrapis/pwrapis_config.ini
    SLEEP_WAIT 5
    userdel -r eagle
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
