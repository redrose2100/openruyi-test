#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
#@Date      	:   2021-02-19
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test QUERY_BEDEPEND dbName pkgName
#####################################

source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    ACT_SERVICE
    INIT_CONF ../../common_lib/openEuler.yaml

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    QUERY_BEDEPEND openeuler-lts PyPAM -install | grep -v "=">./actual_value1
    GET_DNF_REPOQUERY PyPAM openEuler-Source
    code=$(COMPARE_DNF ./actual_value1 ./expect_repoquery)
    CHECK_RESULT "$code" 0 0 "Check bedepend result of PyPAM failed."

    QUERY_BEDEPEND openeuler-lts openhpi -install | grep -v "=" >./actual_value2
    GET_DNF_REPOQUERY openhpi openEuler-Source
    code=$(COMPARE_DNF ./actual_value2 ./expect_repoquery)
    CHECK_RESULT "$code" 0 0 "Check bedepend result of openhpi failed."

    QUERY_BEDEPEND openeuler-lts Judy -install | grep -v "=" >./actual_value3
    GET_DNF_REPOQUERY Judy openEuler-Source
    code=$(COMPARE_DNF ./actual_value3 ./expect_repoquery)
    CHECK_RESULT "$code" 0 0 "Check bedepend result of Judy failed."

    # Get ramdom package to search
    for i in {1..5}; do
        pkg_name=$(GET_RANDOM_PKGNAME openEuler_20.09_src.sqlite)
        LOG_INFO "Check random package: ""$pkg_name"
        QUERY_BEDEPEND openeuler-lts "$pkg_name" -install | grep -v "=" >./actual_value
        GET_DNF_REPOQUERY "$pkg_name" openEuler-Source
        code=$(COMPARE_DNF ./actual_value ./expect_repoquery)
        CHECK_RESULT "$code" 0 0 "Check bedepend result of "$pkg_name" failed."
    done

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the tet environment."

    rm -f ./actual_value* ./dnf_repoquery ./expect_repoquery
    REVERT_ENV

    LOG_INFO "End to restore the tet environment."
}

main "$@"
