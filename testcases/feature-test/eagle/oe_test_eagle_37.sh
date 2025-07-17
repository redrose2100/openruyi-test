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
#@Date          :   2024-07-16
#@License       :   Mulan PSL v2
#@Desc          :   user eagle force released by root test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ! [ "${NODE1_FRAME}" = "aarch64" ] && [ "${NODE1_MACHINE}" = "physical" ]; then
       echo "eagle仅支持aarch64架构和物理机!"
       exit 255
    fi
    echo > /var/log/eagle/eagle.log
    echo > /var/log/pwrapis/papis.log
    DNF_INSTALL "eagle powerapi-devel gcc"
    cp common/demo_main.c ./
    gcc demo_main.c -o demo_main -lpwrapi
    LOG_INFO "End to to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ./demo_main | grep "RequestControlAuth succeed"
    CHECK_RESULT $? 0 0 "Check user root RequestControlAuth failed"
    SLEEP_WAIT 5
    grep "ERROR PWRAPI: Not authorized" /var/log/eagle/eagle.log
    CHECK_RESULT $? 0 0 "Check user eagle Not authorized failed"
    grep "Auth owned by .* force released by root" /var/log/pwrapis/papis.log
    CHECK_RESULT $? 0 0 "Check user eagle force released by root failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf demo_main*
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
