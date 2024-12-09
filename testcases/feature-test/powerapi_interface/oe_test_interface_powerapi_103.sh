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
#@Desc          :   PWR_PROC_SetSmartGridLevel() procs boundary value test
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
    TEST_PWR_PROC_SetAndGetSmartGridProcs(curlevel, pidsnum, pids);
    PWR_ReleaseControlAuth();
    TEST_PWR_UnRegister();
    return 0;
}
" >> demo_main.c
    cp demo_main.c demo_main1.c
    cp demo_main.c demo_main2.c
    cp demo_main.c demo_main3.c
    cp demo_main.c demo_main4.c
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    sh runtest.sh 5000
    pgrep -f "sh test.sh"| wc -l
    pid=$(pgrep -f "sh test.sh"| xargs)
    sed -i 's/curlevel/0/' demo_main1.c
    sed -i 's/pidsnum/5000/' demo_main1.c
    sed -i 's/pidlist/'"${pid}"'/' demo_main1.c
    gcc ./demo_main1.c -o demo_main -lpwrapi
    ./demo_main | grep -A8 "SetSmartGridLevel succeed" | grep "PWR_PROC_GetSmartGridProcs: ret:0 num:5000"
    CHECK_RESULT $? 0 0 "Check interface SetSmartGridLevel procs is 5000 level=0 failed"
    for id in ${pid}
    do
        grep 0 /proc/"${id}"/smart_grid_level
        CHECK_RESULT $? 0 0 "Check interface SetSmartGridLevel procs is 5000 level=0 failed"
    done
    
    sed -i 's/curlevel/1/' demo_main2.c
    sed -i 's/pidsnum/5000/' demo_main2.c
    sed -i 's/pidlist/'"${pid}"'/' demo_main2.c
    gcc ./demo_main2.c -o demo_main -lpwrapi
    ./demo_main | grep -A8 "SetSmartGridLevel succeed" | grep "PWR_PROC_GetSmartGridProcs: ret:0 num:5000"
    CHECK_RESULT $? 0 0 "Check interface SetSmartGridLevel procs is 5000 level=1 failed"
    for id in ${pid}
    do
        grep 1 /proc/"${id}"/smart_grid_level
        CHECK_RESULT $? 0 0 "Check interface SetSmartGridLevel procs is 5000 level=1 failed"
    done
    pkill -9 -f "test.sh"

    sh runtest.sh 5001
    pid=$(pgrep -f "sh test.sh"| xargs)
    sed -i 's/curlevel/0/' demo_main3.c
    sed -i 's/pidsnum/5001/' demo_main3.c
    sed -i 's/pidlist/'"${pid}"'/' demo_main3.c
    gcc ./demo_main3.c -o demo_main -lpwrapi
    ./demo_main | grep "PWR_PROC_SetSmartGridLevel: ret:6"
    CHECK_RESULT $? 0 0 "Check interface SetSmartGridLevel procs is 5001 level=0 failed"
    for id in ${pid}
    do
        grep 0 /proc/"${id}"/smart_grid_level
        CHECK_RESULT $? 1 0 "Check interface SetSmartGridLevel procs is 5001 level=0 failed"
    done
    
    sed -i 's/curlevel/1/' demo_main4.c
    sed -i 's/pidsnum/5001/' demo_main4.c
    sed -i 's/pidlist/'"${pid}"'/' demo_main3.c
    gcc ./demo_main4.c -o demo_main -lpwrapi
    ./demo_main | grep "PWR_PROC_SetSmartGridLevel: ret:6"
    CHECK_RESULT $? 0 0 "Check interface SetSmartGridLevel procs is 5001 level=1 failed"
    for id in ${pid}
    do
        grep 1 /proc/"${id}"/smart_grid_level
        CHECK_RESULT $? 1 0 "Check interface SetSmartGridLevel procs is 5001 level=1 failed"
    done
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

