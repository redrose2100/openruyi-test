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
#@Desc      	:   Take the test pkgship selfbuild {binaryName} -t binary -w 0/1 -s 0/1
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    ACT_SERVICE
    INIT_CONF ../../common_lib/openEuler_fedora.yaml

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
 
    pkgship selfdepend setup -dbs openeuler-lts fedora33 -b -s | grep "star" | grep -q "openeuler-lts"
    CHECK_RESULT $? 0 0 "Check the result of setup with selfdepend failed."
    pkgship selfdepend setup -dbs openeuler-lts fedora33 -b -w | grep "perl" | grep -q "openeuler-lts"
    CHECK_RESULT $? 0 0 "Check the result of setup with subpack failed."
    pkgship selfdepend setup -dbs openeuler-lts fedora33 -b -w -s | grep "lua" | grep -q "openeuler-lts"
    CHECK_RESULT $? 0 0 "Check the result of setup with subpack and selfdepend failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
