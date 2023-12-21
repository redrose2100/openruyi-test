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
#@Desc      	:   Take the test QUERY_INSTALLDEP {binaryName list} command
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

    dnf install Judy --installroot=/home --repo=openEuler-Binary --setopt=install_weak_deps=false --releasever=1 --assumeno | grep openEuler-Binary | awk '{print $1}' | sort  >expect_val1
    dnf install openEuler-repos --installroot=/home --repo=openEuler-Binary --setopt=install_weak_deps=false --releasever=1 --assumeno | grep openEuler-Binary | awk '{print $1}' | sort >expect_val2
    dnf install CUnit --installroot=/home --repo=openEuler-Binary --setopt=install_weak_deps=false --releasever=1 --assumeno | grep openEuler-Binary | awk '{print $1}' | sort >expect_val3
    cat expect_val1 expect_val2 expect_val3 | sort | uniq >expect_val4
    
    GET_INSTALLDEP "Judy openEuler-repos CUnit" actual_val1
    actual_num=$(QUERY_INSTALLDEP "Judy openEuler-repos CUnit" | grep "Binary Sum" -C 2 | tail -n 1 | awk '{print $2}')
    expect_num=$(wc -l expect_val4 | awk '{print $1}')
    code=$(COMPARE_DNF expect_val4 actual_val1)
    if [[ $actual_num -eq $expect_num && $code == 0 ]]; then
        CHECK_RESULT 0 0 0 "The search result of Judy openEuler-repos CUnit"
    else
        CHECK_RESULT 1 0 0 "The search result of Judy openEuler-repos CUnit is error."
    fi

    GET_INSTALLDEP "Judy openEuler-repos CUnit" actual_val2
    actual_num=$(QUERY_INSTALLDEP "Judy openEuler-repos CUnit xyztest abctest" | grep "Binary Sum" -C 2 | tail -n 1 | awk '{print $2}')
    code=$(COMPARE_DNF expect_val4 actual_val2)
    if [[ $actual_num -eq $expect_num && $code == 0 ]]; then
        CHECK_RESULT 0 0 0 "The search result of Judy openEuler-repos CUnit xyztest abctest"
    else
        CHECK_RESULT 1 0 0 "The search result of Judy openEuler-repos CUnit xyztest abctest is error."
    fi

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf  ./actual* ./expect*
    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
