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
#@Date      	:   2021-02-18
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test pkgship builddep {srcName} command
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."

    ACT_SERVICE
    INIT_CONF ./conf.yaml

    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."

    para=('A' 'B' 'C' 'D' 'E')
    for i in $(seq 0 $((${#para[@]} - 1))); do
        pkgship builddep "${para[$i]}" -dbs | grep -v "=" &>./actual_value"$i".txt
        COMPARE_DNF ./actual_value"$i".txt ./expect_value"$i".txt
        CHECK_RESULT $? 0 0 "Check builddep for ${para[$i]} failed."
    done

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf ./actual_value* ./expect_value*
    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
