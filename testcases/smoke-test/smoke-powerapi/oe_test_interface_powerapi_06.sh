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
#@Author        :   jinye
#@Contact       :   jinye10@huawei.com
#@Date          :   2024-10-29
#@License       :   Mulan PSL v2
#@Desc          :   PWR_SetServerInfo() test1 (sock file no permission)test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if [ "${NODE1_MACHINE}" != "physical" ]; then
        LOG_INFO "The environment does not support testing"
        exit 0
    fi
    DNF_INSTALL "powerapi-devel gcc"
    sock_file="/test/sysconfig/pwrapis/pwrserver.sock"
    sock_path=$(dirname ${sock_file})
    useradd test1
    cp /etc/sysconfig/pwrapis/pwrapis_config.ini /etc/sysconfig/pwrapis/pwrapis_config.ini_bak
    sed -i 's#sock_file=.*#sock_file='${sock_file}'#' /etc/sysconfig/pwrapis/pwrapis_config.ini
    sed -i 's#admin=.*#admin=root,test1#' /etc/sysconfig/pwrapis/pwrapis_config.ini
    cp common/demo_main.c ./
    sed -i 's#sock_file\[\] =.*#sock_file[] = "'"${sock_file}"'";#' demo_main.c
    echo "int main(int argc, const char *args[])
{
    TEST_PWR_SetServerInfo();
    TEST_PWR_Register();
    return 0;
}
" >> demo_main.c
    gcc ./demo_main.c -o demo_main -lpwrapi
    cp demo_main /home/test1/
    systemctl restart pwrapis
    SLEEP_WAIT 30
    chmod 744 "${sock_path}"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    su test1 -c "./demo_main" > test.log &
    SLEEP_WAIT 180
    grep "Server sock doesn't exist. Check server addr path please." test.log
    CHECK_RESULT $? 0 0 "Check interface PWR_SetServerInfo failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    pgrep -f demo_main | xargs kill -9
    userdel -r test1
    mv -f /etc/sysconfig/pwrapis/pwrapis_config.ini_bak /etc/sysconfig/pwrapis/pwrapis_config.ini
    systemctl restart pwrapis
    DNF_REMOVE "$@"
    rm -rf demo_main* pwrclient.sock test.log /test
    LOG_INFO "End to restore the test environment."
}

main "$@"
