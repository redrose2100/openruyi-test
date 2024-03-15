#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
#@Date      	:   2024-01-25
#@License   	:   Mulan PSL v2
#@Desc      	:   Pkgship auto start
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    systemctl start pkgship
    CHECK_RESULT $? 0 0 "systemctl start pkgship failed."
    for i in $(pgrep -f -a "pkgship|uwsgi" | grep -Ev "bash|grep" | awk '{print $1}'); do
        kill -9 "$i"
    done
    SLEEP_WAIT 20
    systemctl status pkgship | grep -E "deactivating|active"
    CHECK_RESULT $? 0 0 "pkgship auto start failed."
    systemctl stop pkgship
    CHECK_RESULT $? 0 0 "systemctl stop pkgship failed."
    systemctl status pkgship | grep -E "failed|inactive"
    CHECK_RESULT $? 0 0 "pkgship close failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
