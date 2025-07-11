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
    if [[ "${NODE1_FRAME}" != "x86_64" && "${NODE1_FRAME}" != "aarch64" ]]; then
        LOG_WARN "Current architecture (${NODE1_FRAME}) is not supported by powerapi, skipping test."
        exit 255
    fi
    DNF_INSTALL "powerapi-devel gcc"
    echo "while true;do sleep 1;done" >> test.sh
    cp test.sh t.sh
    echo "for((i=1;i<=5000;i++));
do
    sh test.sh &
done" > runtest.sh
    cp common/demo_main.c ./
    echo "int main(int argc, const char *args[])
{
    TEST_PWR_Register();
    TEST_PWR_PROC_QueryProcs_1(\"sh t.sh\", 1);
    TEST_PWR_PROC_QueryProcs_1(\"sh test.sh\", 5000);
    TEST_PWR_PROC_QueryProcs_1(\"sh runtest.sh|sh test.sh\", 5001);
    TEST_PWR_PROC_QueryProcs_1(\"\", 0);
    TEST_PWR_UnRegister();
    return 0;
}
" >> demo_main.c
    gcc ./demo_main.c -o demo_main -lpwrapi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    sh t.sh &
    sh runtest.sh
    ./demo_main > test.log
    grep -A5 "keywords:sh t.sh" test.log | grep -Pz "\[DEBUG\]    QueryProcsByKeywords succeed.\nPWR_PROC_QueryProcs. ret: 0 num:1"
    CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_QueryProcs failed"
    grep -A5 "keywords:sh test.sh" test.log | grep -Pz "\[DEBUG\]    QueryProcsByKeywords succeed.\nPWR_PROC_QueryProcs. ret: 0 num:5000"
    CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_QueryProcs failed"
    grep -A5 "keywords:sh runtest.sh|sh test.sh" test.log | grep -Pz "\[DEBUG\]    QueryProcsByKeywords succeed.\nPWR_PROC_QueryProcs. ret: 0 num:5000"
    CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_QueryProcs failed"
    grep -A1 "keywords:$" test.log | grep "PWR_PROC_QueryProcs. ret: 6 num:0"
    CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_QueryProcs failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    pkill -9 -f "test.sh"
    rm -rf demo_main* test.log /root/pwrclient.sock test.sh runtest.sh t.sh
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"

