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
#@Author    	:   Li, Meiting
#@Contact   	:   244349477@qq.com
#@Date      	:   2021-02-18
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test QUERY_PKGINFO
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
    LOG_INFO "Start to run test. "

    QUERY_PKGINFO git openeuler-lts -s >./actual_result1
    dnf deplist git --repo=openEuler-Source | grep dependency | awk '{print $2}' | sort >./dnf_result1
    code=$(COMPARE_DNF ./actual_result1 ./dnf_result1)
    CHECK_RESULT "$code" 0 0 "Check failed for git."

    QUERY_PKGINFO lshw openeuler-lts -s >./actual_result2
    dnf deplist lshw --repo=openEuler-Source | grep dependency | awk '{print $2}' | sort >./dnf_result2
    code=$(COMPARE_DNF ./actual_result2 ./dnf_result2)
    CHECK_RESULT "$code" 0 0 "Check failed for lshw."

    for i in {1..5}; do
        pkg_name=$(GET_RANDOM_PKGNAME openEuler_20.03_src_list)
        LOG_INFO "Check random package: $pkg_name"
        QUERY_PKGINFO "$pkg_name" openeuler-lts -s >./actual_result
        dnf deplist "$pkg_name" --repo=openEuler-Source | grep dependency | awk '{print $2}' | sort >./dnf_result
        code=$(COMPARE_DNF ./actual_result ./dnf_result)
        CHECK_RESULT "$code" 0 0 "Check $i failed for $pkg_name."
    done

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf ./expect_filelist ./dnf_result* pkgship_result* ./*.rpm actual_result*
    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
