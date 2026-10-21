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
#@Author    	:   meiting
#@Contact   	:   244349477@qq.com
#@Date      	:   2023-02-18
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test QUERY_INSTALLDEP {binary list} command
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    ACT_SERVICE
    INIT_CONF ../../common_lib/openEuler.yaml

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    dnf install Judy --installroot=/home --repo=openEuler-Binary --releasever 1 --assumeno | awk '{print $1}' | grep -Ev "Transaction|=|Install|Total" >./expect_value_Judy
    dnf install CUnit --installroot=/home --repo=openEuler-Binary --releasever 1 --assumeno | awk '{print $1}' | grep -Ev "Transaction|=|Install|Total" >./expect_value_CUnit
    cat ./expect_value_Judy ./expect_value_CUnit | sort | uniq >expect_value

    GET_INSTALLDEP "Judy CUnit" actual_value1 "openeuler-lts" 1
    code=$(COMPARE_DNF ./expect_value ./actual_value1)
    CHECK_RESULT "$code" 0 0 "The compare result of pkgship and dnf is different for level 1."

    GET_INSTALLDEP "Judy CUnit" actual_value2 "openeuler-lts" 2
    code=$(COMPARE_DNF ./expect_value ./actual_value2)
    CHECK_RESULT "$code" 0 0 "The compare result of pkgship and dnf is different for level 2."

    GET_INSTALLDEP "Judy CUnit" actual_value3 "openeuler-lts" 500000
    code=$(COMPARE_DNF ./expect_value ./actual_value3)
    CHECK_RESULT "$code" 0 0 "The compare result of pkgship and dnf is different for level 500000."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf  ./actual_value* ./expect_value*
    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
