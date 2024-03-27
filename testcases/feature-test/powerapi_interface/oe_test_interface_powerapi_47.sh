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
#@Desc          :   set file_size=1 cmp_cnt=2 test
#####################################

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
    TEST_PWR_CPU_GetInfo();
    TEST_PWR_CPU_GetFreqAbility();
    TEST_PWR_CPU_GetFreqGovernor();
    TEST_PWR_CPU_GetIdleInfo();
    TEST_PWR_CPU_SetFreqGovernor();
    TEST_PWR_CPU_GetFreqGovAttrs();
    TEST_PWR_CPU_GetFreqGovAttr_Exists_Attr();
    TEST_PWR_CPU_GetFreqGovAttr_NoExists_Attr();
    TEST_PWR_CPU_GetFreqGovAttr_NoExists_Attr_1();
    TEST_PWR_CPU_SetFreqGovAttr_Success();
    TEST_PWR_CPU_SetFreqGovAttr_Failure();
    TEST_PWR_CPU_SetFreqGovAttr_Failure_1();
    TEST_PWR_CPU_GetFreqRange();
    TEST_PWR_CPU_SetFreqRange_1();
    TEST_PWR_CPU_SetFreqRange_2();
    TEST_PWR_CPU_SetFreqRange_3();
    TEST_PWR_CPU_SetFreqRange_4();
    TEST_PWR_CPU_GetFreq_1();
    TEST_PWR_CPU_GetFreq_2();
    TEST_PWR_CPU_GetFreq_3();
    TEST_PWR_CPU_SetFreq_1();
    TEST_PWR_CPU_SetFreq_2();
    TEST_PWR_CPU_SetFreq_3();
    TEST_PWR_CPU_SetFreq_4();
    TEST_PWR_CPU_GetIdleGovernor();
    TEST_PWR_CPU_DmaGetLatency();
    TEST_PWR_CPU_DmaSetLatency_1();
    TEST_PWR_CPU_DmaSetLatency_2();
    TEST_PWR_CPU_DmaSetLatency_3();
    TEST_PWR_CPU_DmaSetLatency_4();
    TEST_PWR_CPU_DmaSetLatency_5();
    TEST_PWR_CPU_DmaSetLatency_6();
    PWR_ReleaseControlAuth();
    TEST_PWR_UnRegister();
    return 0;
}
" >> demo_main.c
    gcc ./demo_main.c -o demo_main -lpwrapi
    echo "while true; do
    ./demo_main
done" > test.sh
    cp /etc/sysconfig/pwrapis/pwrapis_config.ini /etc/sysconfig/pwrapis/pwrapis_config.ini_bak
    sed -i 's#log_level=.*#log_level=0#' /etc/sysconfig/pwrapis/pwrapis_config.ini
    sed -i 's#file_size=.*#file_size=1#' /etc/sysconfig/pwrapis/pwrapis_config.ini
    sed -i 's#cmp_cnt=.*#cmp_cnt=2#' /etc/sysconfig/pwrapis/pwrapis_config.ini
    systemctl restart pwrapis.service
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    nohup sh test.sh > /dev/null &
    SLEEP_WAIT 600
    find /var/log/pwrapis/bak/*.tar.gz | wc -l | grep -w 2
    CHECK_RESULT $? 0 0 "Check interface PWR_RequestControlAuth failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    pgrep -f "sh test.sh" | xargs kill -9
    mv -f /etc/sysconfig/pwrapis/pwrapis_config.ini_bak /etc/sysconfig/pwrapis/pwrapis_config.ini
    systemctl restart pwrapis.service
    rm -rf demo_main* pwrclient.sock /var/log/pwrapis/* test.sh
    systemctl start tuned
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
