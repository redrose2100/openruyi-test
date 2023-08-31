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

    QUERY_BEDEPEND openeuler-lts PyPAM -build | grep -q "openeuler-lts"
    CHECK_RESULT $? 0 0 "Check bedepend result of PyPAM failed."
    QUERY_BEDEPEND openeuler-lts openhpi -build | grep -q "openeuler-lts"
    CHECK_RESULT $? 0 0 "Check bedepend result of openhpi failed."
    QUERY_BEDEPEND openeuler-lts Judy -build | grep -q "openeuler-lts"
    CHECK_RESULT $? 0 0 "Check bedepend result of Judy failed."
    QUERY_BEDEPEND openeuler-lts SDL -build | grep -q "openeuler-lts"
    CHECK_RESULT $? 0 0 "Check bedepend result of SDL failed."
    
    # Get ramdom package to search
    for i in {1..5}; do
        pkg_name=$(GET_RANDOM_PKGNAME openEuler_20.03_src.sqlite)
        LOG_INFO "Check random package: "$pkg_name
        result=$(QUERY_BEDEPEND openeuler-lts $pkg_name -build)
        if [[ "$result" =~ "openeuler-lts" ]]; then
            CHECK_RESULT 0
        else
            CHECK_RESULT 1 0 0 "Check bedepend result of $pkg_name failed."
        fi
    done

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the tet environment."

    REVERT_ENV
    
    LOG_INFO "End to restore the tet environment."
}

main "$@"
