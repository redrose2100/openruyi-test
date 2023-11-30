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
#@Date      	:   2023-02-18
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test pkgship selfbuild {sourceName}
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    ACT_SERVICE
    INIT_CONF ./conf.yaml

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    pkgship selfdepend A  -dbs fedora openeuler data1 -s | grep -q "data1"
    CHECK_RESULT $? 0 0 "Check builddep for F -s failed."
    pkgship selfdepend A fedora openeuler data1 -w | grep -q "data1"
    CHECK_RESULT $? 0 0 "Check builddep for F -w failed."
    pkgship selfdepend A -dbs fedora openeuler data1 -w -s | grep -q "data1"
    CHECK_RESULT $? 0 0 "Check builddep for F -w -s failed."
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"

