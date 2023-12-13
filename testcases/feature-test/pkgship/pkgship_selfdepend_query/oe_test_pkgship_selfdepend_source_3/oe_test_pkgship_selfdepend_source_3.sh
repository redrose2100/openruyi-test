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

    pkgship selfdepend Judy glibc| grep -Eq "Judy|glibc"
    CHECK_RESULT $? 0 0 "Check the self depend of Judy glibc failed."
    pkgship selfdepend Judy glibc testA testB | grep -q "zlib"
    CHECK_RESULT $? 0 0 "Check the self depend of Judy glibc testA testB failed."
    pkgship selfdepend CUnit glibc -dbs -s | grep -q "systemd"
    CHECK_RESULT $? 0 0 "Check the self depend of CUnit glibc -s failed."
    pkgship selfdepend CUnit glibc -dbs -w | grep -q "libsoup"
    CHECK_RESULT $? 0 0 "Check the self depend of CUnit glibc -w failed."
    pkgship selfdepend CUnit glibc -dbs -w -s | grep -q "acl"
    CHECK_RESULT $? 0 0 "Check the self depend of CUnit glibc -w -s failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
