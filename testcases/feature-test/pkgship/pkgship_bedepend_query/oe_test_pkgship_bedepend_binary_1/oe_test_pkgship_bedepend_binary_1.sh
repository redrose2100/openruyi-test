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
#@Date      	:   2021-02-19
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test pkgship bedepend dbName pkgName
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    ACT_SERVICE

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    pkgship bedepend openeuler-lts openhpi -b | grep -v "=" >./actual_value2
    GET_DNF_REPOQUERY openhpi
    code=$(COMPARE_DNF ./actual_value2 ./expect_repoquery)
    CHECK_RESULT "$code" 0 0 "Check bedepend result of openhpi failed."
     
    pkgship bedepend openeuler-lts Judy -b | grep -v "=" >./actual_value3
    GET_DNF_REPOQUERY Judy
    code=$(COMPARE_DNF ./actual_value3 ./expect_repoquery)
    CHECK_RESULT "$code" 0 0 "Check bedepend result of Judy failed."

    # Get ramdom package to search
    for i in {1..5} 
    do
        pkg_name=$(GET_RANDOM_PKGNAME openEuler_20.03_bin_list)
        LOG_INFO "Check random package: ""$pkg_name"
        pkgship bedepend openeuler-lts "$pkg_name" -b | grep -v "=" >./actual_value
        GET_DNF_REPOQUERY "$pkg_name"
        code=$(COMPARE_DNF ./actual_value ./expect_repoquery)
        CHECK_RESULT "$code" 0 0 "Check '$i' bedepend result of '$pkg_name' failed."
    done

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    REVERT_ENV
    
    LOG_INFO "End to restore the test environment."
}

main "$@"
