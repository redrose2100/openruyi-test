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
#@Desc          :   normal user PWR_CreateDcTask() and PWR_DeleteDcTask() repeat test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "powerapi-devel gcc"
    useradd test1
    sed -i "s/admin=root/admin=test1/g" /etc/sysconfig/pwrapis/pwrapis_config.ini
    cp common/demo_main.c ./
    echo "int main(int argc, const char *args[])
{
    TEST_PWR_Register();
    TEST_PWR_COM_DcTaskMgr();
    TEST_PWR_UnRegister();
    return 0;
}
" >> demo_main.c
    gcc ./demo_main.c -o demo_main -lpwrapi
    cp demo_main /home/test1/
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    SLEEP_WAIT 5
    su - test1 -c "./demo_main"  > test.log
    grep -A1 "PWR_CreateDcTask        :SUCCESS ret: 0" test.log | grep "dataType:1"
    CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param dataType is 1 failed"
    grep -A1 "PWR_CreateDcTask        :SUCCESS ret: 0" test.log | grep "dataType:2"
    CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param dataType is 2 failed"
    grep -A1 "PWR_CreateDcTask        :ERROR   ret: 6" test.log | grep "dataType:3"
    CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param dataType is 3 failed"
    grep -A1 "PWR_CreateDcTask        :ERROR   ret: 6" test.log | grep "dataType:4"
    CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param dataType is 4 failed"
    grep -A1 "PWR_CreateDcTask        :ERROR   ret: 6" test.log | grep "dataType:-1"
    CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param dataType is -1 failed"
    grep -A1 "PWR_DeleteDcTask        :SUCCESS ret: 0" test.log | grep "dataType:1"
    CHECK_RESULT $? 0 0 "Check interface PWR_DeleteDcTask with Param dataType is 1 failed"
    grep -A1 "PWR_DeleteDcTask        :SUCCESS ret: 0" test.log | grep "dataType:2"
    CHECK_RESULT $? 0 0 "Check interface PWR_DeleteDcTask with Param dataType is 2 failed"
    grep -A1 "PWR_DeleteDcTask        :ERROR   ret: 401" test.log | grep "dataType:3"
    CHECK_RESULT $? 0 0 "Check interface PWR_DeleteDcTask with Param dataType is 3 failed"
    grep "Get cpu usage" test.log
    CHECK_RESULT $? 0 0 "Check PWR_COM_DATATYPE_CPU_USAGE failed"
    grep "Get perf data" test.log
    CHECK_RESULT $? 0 0 "Check PWR_COM_DATATYPE_CPU_PERF failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf demo_main* test.log
    sed -i "s/admin=test1/admin=root/g" /etc/sysconfig/pwrapis/pwrapis_config.ini
    SLEEP_WAIT 5
    userdel -r test1
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
