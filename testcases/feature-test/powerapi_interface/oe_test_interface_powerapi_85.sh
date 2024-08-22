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
#@Desc          :   PWR_PROC_QueryProcs() about the keyword is empty test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "powerapi-devel gcc"
    cp common/demo_main.c ./
    echo "int main(int argc, const char *args[])
{
    TEST_PWR_Register();
    TEST_PWR_PROC_QueryProcs(\"\");
    TEST_PWR_PROC_QueryProcs(NULL);
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
    get_num=$(grep "PWR_PROC_QueryProcs. ret: 0 num:" test.log | head -n 1| awk -F "num:" '{print $2}')
    test "$(grep -A1 "\[DEBUG\]    QueryProcsByKeywords succeed" test.log | grep -c "PWR_PROC_QueryProcs. ret: 0 num:${get_num}")" -eq 2 -a "$(grep -c "procs" test.log)" -eq "$(("${get_num}"*2))"
    CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_QueryProcs failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf demo_main* test.log /root/pwrclient.sock
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
