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
#@Date      	:   2023-07-23
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test QUERY_INSTALLDEP {binaryName} command
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

    # Test binary without depend
    QUERY_INSTALLDEP openEuler-gpg-keys >/dev/null
    CHECK_RESULT $? 0 0 "The search result of openEuler-gpg-keys is error."

    # Test binary with one level depend
    GET_INSTALLDEP openEuler-repos actual_val1
    dnf install openEuler-repos --installroot=/home --repo=openEuler-Binary --setopt=install_weak_deps=false --releasever=1 --assumeno | grep openEuler-Binary | awk '{print $1}' | sort >expect_val1
    actual_num=$(QUERY_INSTALLDEP openEuler-repos | grep "Binary Sum" -C 2 | tail -n 1 | awk '{print $2}')
    expect_num=$(dnf install openEuler-repos --installroot=/home --repo=openEuler-Binary --releasever=1 --setopt=install_weak_deps=false --assumeno | grep "Total download size" -B 2 | head -n 1 | awk '{print $2}')
    code=$(COMPARE_DNF expect_val1 actual_val1)
    if [[ $actual_num -ne $expect_num || $code -ne 0 ]]; then
        CHECK_RESULT 1 0 0 "The search result of openEuler-repos is error."
    fi

    # Test binary with multiple level depend
    GET_INSTALLDEP glibc actual_val2
    dnf install glibc --installroot=/home --repo=openEuler-Binary --setopt=install_weak_deps=false --releasever=1 --assumeno | grep openEuler-Binary | awk '{print $1}' | sort >expect_val2
    actual_num=$(QUERY_INSTALLDEP glibc | grep "Binary Sum" -C 2 | tail -n 1 | awk '{print $2}')
    expect_num=$(dnf install glibc --installroot=/home --repo=openEuler-Binary --releasever=1 --setopt=install_weak_deps=false --assumeno | grep "Total download size" -B 2 | head -n 1 | awk '{print $2}')
    code=$(COMPARE_DNF expect_val2 actual_val2)
    if [[ $actual_num -ne $expect_num || $code -ne 0 ]]; then
        CHECK_RESULT 1 0 0 "The search result of glibc is error."
    fi

    GET_INSTALLDEP coreutils actual_val3
    dnf install coreutils --installroot=/home --repo=openEuler-Binary --setopt=install_weak_deps=false --releasever=1 --assumeno | grep openEuler-Binary | awk '{print $1}' | sort >expect_val3
    actual_num=$(QUERY_INSTALLDEP coreutils | grep "Binary Sum" -C 2 | tail -n 1 | awk '{print $2}')
    expect_num=$(dnf install coreutils --installroot=/home --repo=openEuler-Binary --releasever=1 --setopt=install_weak_deps=false --assumeno | grep "Total download size" -B 2 | head -n 1 | awk '{print $2}')
    code=$(COMPARE_DNF expect_val3 actual_val3)
    if [[ $actual_num -ne $expect_num || $code -ne 0 ]]; then
        CHECK_RESULT 1 0 0 "The search result of coreutils is error."
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
