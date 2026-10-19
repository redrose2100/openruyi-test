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
#@Desc      	:   Take the test pkgship selfdepend {binaryName} command
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

    pkgship selfdepend openEuler-gpg-keys -dbs -b | grep -q "openEuler-gpg-keys"
    CHECK_RESULT $? 0 0 "Check the self depend of binary  openEuler-gpg-keys failed."
    pkgship selfdepend openEuler-repos -dbs -b | grep -q "openEuler-repos"
    CHECK_RESULT $? 0 0 "Check the self depend of binary openEuler-repos failed."
    pkgship selfdepend glibc openeuler-lts -b | grep -q "openeuler-lts"
    CHECK_RESULT $? 0 0 "Check the self depend of binary glibc failed."
    pkgship selfdepend zlib-devel -dbs -b | grep -q "openeuler-lts"
    CHECK_RESULT $? 0 0 "Check the self depend of binary zlib-devel failed."

    # Get random package
    for i in {1..5}; do
        pkg_name=$(GET_RANDOM_PKGNAME openEuler_20.03_bin_list)
        LOG_INFO "Check self depend for package: ""$pkg_name"
        pkgship selfdepend "$pkg_name" -dbs -b | grep -q "openeuler-lts"
        CHECK_RESULT $? 0 0 "Check the self depend of binary $pkg_name for number '$i'failed."
    done

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"

