#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   meitingli
#@Contact   	:   244349477@qq.com
#@Date      	:   2023-07-30
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test compare build data comparison between dbs failed
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    ACT_SERVICE
    INIT_CONF ../../common_lib/openEuler_fedora.yaml
    ori_num=$(wc -l /opt/pkgship/compare | awk '{print $1}')

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    pkgship compare -t build -dbs A B 2>&1 | grep "\[ERROR\] Database (A) is not supported, please enter again."
    CHECK_RESULT $? 0 0 "The message is error when set dbs not exist."
    CHECK_RESULT "$(wc -l /opt/pkgship/compare | awk '{print $1}')" "$ori_num" 0 "It created comparison file unexpectly."
     
    pkgship compare -t build -dbs openeuler-lts A -o /opt 2>&1 | grep "\[ERROR\] Database (A) is not supported, please enter again."
    CHECK_RESULT $? 0 0 "The message is error when set part of dbs not exist."
    pkgship compare -t build -dbs openeuler1 openeuler2 openeuler3 openeuler4 fedora 2>&1 | grep "\[ERROR\] Supports up to four databases"
    CHECK_RESULT $? 0 0 "The message is error when set 5 dbs."
    pkgship compare -t build -dbs openeuler1 openeuler1 fedora 2>&1 | grep "\[ERROR\] Duplicate database entered"
    CHECK_RESULT $? 0 0 "The message is error when set duplicate dbs."
    pkgship compare -t build -dbs 2>&1 | grep "\[ERROR\] Parameter error, please check the parameter and query again."
    CHECK_RESULT $? 0 0 "The message is error when no paramter."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
