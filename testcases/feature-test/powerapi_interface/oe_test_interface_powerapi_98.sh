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
#@Desc          :   PWR_PROC_GetWattProcs(), PWR_PROC_AddWattProcs() and PWR_PROC_DelWattProcs() test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if [ "${NODE1_FRAME}" != "aarch64" ]; then
        LOG_INFO "The environment does not support testing"
        exit 0
    fi
    DNF_INSTALL "powerapi-devel gcc iperf"
    cp common/demo_main.c ./
    iperf -s &
    PidNum="$(pgrep -f "iperf")"
    echo "int main(int argc, const char *args[])
{
    TEST_PWR_Register();
    PWR_RequestControlAuth();
    TEST_PWR_PROC_AddAndDelWattProcs(${PidNum}); 
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
    < test.log head -n 10 | grep "GetWattProcs failed. ret:301"
    CHECK_RESULT $? 0 0 "Check interface PWR_PROC_GetWattProcs if no proc failed"
    grep "PWR_PROC_AddWattProcs: ret:0" test.log
    CHECK_RESULT $? 0 0 "Check interface PWR_PROC_AddWattProcs failed"
    grep "PWR_PROC_DelWattProcs: ret:0" test.log
    CHECK_RESULT $? 0 0 "Check interface PWR_PROC_DelWattProcs failed"
    < test.log tail -n 10 | grep "GetWattProcs failed. ret:301"
    CHECK_RESULT $? 0 0 "Check interface PWR_PROC_GetWattProcs after del failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf demo_main* test.log /root/pwrclient.sock
    kill -9 "${PidNum}"
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
