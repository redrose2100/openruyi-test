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
#@Date      	:   2020-08-17
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test pkgship selfdep {sourceName} command
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

    pkgship selfdepend openEuler-repos >/dev/null
    CHECK_RESULT $? 0 0 "Check the self depend of openEuler-repos failed."
    pkgship selfdepend openEuler-indexhtml | grep -q "gcc"
    CHECK_RESULT $? 0 0 "Check the self depend of openEuler-indexhtml failed."
    pkgship selfdepend Judy -dbs openeuler-lts | grep -q "gdb"
    CHECK_RESULT $? 0 0 "Check the self depend of Judy failed."

    # Get randome package
    for i in {1..5}; do
	pkg_name=$(GET_RANDOM_PKGNAME openEuler_20.03_src_list)
	LOG_INFO "Check self build for package: ""$pkg_name"
	pkgship selfdepend "$pkg_name" | grep -q "openeuler-lts"
        CHECK_RESULT $? 0 0 "Check the self depend of $pkg_name for numer '$i'failed."
    done

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
