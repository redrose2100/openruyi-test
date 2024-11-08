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
#@Desc          :   PWR_PROC_QueryProcs() boundary value test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ! test -f /sys/fs/cgroup/cpu/cpu.dynamic_affinity_mode; then
        echo "the environment is not support!"
        exit 0
    fi
    DNF_INSTALL "powerapi-devel gcc"
    echo "while true;do sleep 1;done" >> test.sh
    echo "for((i=1;i<=\$1;i++));
do
    sh test.sh &
done" > runtest.sh
    cp common/demo_main.c ./
    echo "int main(int argc, const char *args[])
{
    TEST_PWR_Register();
    PWR_RequestControlAuth();
    char pids[] = \"pidlist\";
    TEST_PWR_PROC_AddAndDelWattProcs_2(pidsnum, pids);
    PWR_ReleaseControlAuth();
    TEST_PWR_UnRegister();
    return 0;
}
" >> demo_main.c
    cp demo_main.c demo_main1.c
    cp demo_main.c demo_main2.c
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    sh runtest.sh 1
    pid=$(pgrep -f "sh test.sh"| xargs)
    sed -i 's/pidsnum/1/' demo_main.c
    sed -i 's/pidlist/'"${pid}"'/' demo_main.c
    gcc ./demo_main.c -o demo_main -lpwrapi
    ./demo_main | grep -e "PWR_PROC_AddWattProcs: ret:0" -e "PWR_PROC_GetWattProcs: ret:0 n:1"
    CHECK_RESULT $? 0 0 "Check interface PWR_PROC_AddWattProcs failed"
    pkill -9 -f "test.sh"
    
    sh runtest.sh 5000
    pid=$(pgrep -f "sh test.sh" | xargs)
    sed -i 's/pidsnum/5000/' demo_main1.c
    sed -i 's/pidlist/'"${pid}"'/' demo_main1.c
    gcc ./demo_main1.c -o demo_main -lpwrapi
    ./demo_main | grep -e "PWR_PROC_AddWattProcs: ret:0" -e "PWR_PROC_GetWattProcs: ret:0 n:5000"
    CHECK_RESULT $? 0 0 "Check interface PWR_PROC_AddWattProcs failed"
    pkill -9 -f "test.sh"
   
    sh runtest.sh 5001
    pid=$(pgrep -f "sh test.sh" | xargs)
    sed -i 's/pidsnum/5001/' demo_main2.c
    sed -i 's/pidlist/'"${pid}"'/' demo_main2.c
    gcc ./demo_main2.c -o demo_main -lpwrapi
    ./demo_main | grep -e "PWR_PROC_AddWattProcs: ret:6"
    CHECK_RESULT $? 0 0 "Check interface PWR_PROC_AddWattProcs failed"
    pkill -9 -f "test.sh"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    pkill -9 -f "test.sh"
    rm -rf demo_main* /root/pwrclient.sock test.sh runtest.sh
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"

