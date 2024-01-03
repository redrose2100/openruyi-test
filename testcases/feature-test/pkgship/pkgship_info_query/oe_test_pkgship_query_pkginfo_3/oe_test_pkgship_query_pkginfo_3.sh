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
#@Date      	:   2023-07-27
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test pkgship single
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    ACT_SERVICE
    if [ "${NODE1_FRAME}" = "x86_64" ]; then
        sed -i "s/aarch64/x86_64/g" ./conf.yaml
    fi
    INIT_CONF ./conf.yaml

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    QUERY_PKGINFO git-daemon fedora >/dev/null
    CHECK_RESULT $? 0 0 "Search pkginfo from fedora failed."
    QUERY_PKGINFO git-daemon openeuler
    CHECK_RESULT $? 0 0 "Search pkginfo from openEuler-20.09-OS failed."

    QUERY_PKGINFO git fedora -s
    CHECK_RESULT $? 0 0 "Search source pkginfo from fedora failed."
    QUERY_PKGINFO git openeuler -s
    CHECK_RESULT $? 0 0 "Search source pkginfo from openEuler-20.09-OS failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    REVERT_ENV
    if [ "${NODE1_FRAME}" = "x86_64" ]; then
        sed -i "s/x86_64/aarch64/g" ./conf.yaml
    fi

    LOG_INFO "End to restore the test environment."
}

main "$@"
