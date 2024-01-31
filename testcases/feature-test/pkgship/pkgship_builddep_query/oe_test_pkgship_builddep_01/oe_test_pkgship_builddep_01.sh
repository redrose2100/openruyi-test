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
#@Date      	:   2021-02-18
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test pkgship builddep {srcName} command
###################################### shellcheck disable=SC1091
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."

    ACT_SERVICE
    INIT_CONF ../../common_lib/openEuler.yaml

    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test package without build depend
    pkgship builddep openEuler-repos >/dev/null
    CHECK_RESULT $? 0 0 "Check the builddep for openEuler-repos failed."

    # Test package with multiple build depend
    pkgship builddep coreutils >./actual_value1
    GET_DNF_BUILDDEPLIST coreutils 10000 >./expect_value1
    COMPARE_DNF ./actual_value1 ./expect_value1
    CHECK_RESULT $? 0 0 "Check the builddep for coreutils failed."

    # Get random package name to search
    for i in {1..5}; do
        pkg_name=$(GET_RANDOM_PKGNAME openEuler_20.03_src_list)
        LOG_INFO "Check builddep for package: $pkg_name"
        pkgship builddep "$pkg_name" &>./actual_value"$i"
        GET_DNF_BUILDDEPLIST "$pkg_name" 10000 >./expect_value"$i"
        COMPARE_DNF ./actual_value"$i" ./expect_value"$i"
        CHECK_RESULT $? 0 0 "Check the builddep for $pkg_name failed."
    done

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf ./actual_value* ./expect_value*
    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
