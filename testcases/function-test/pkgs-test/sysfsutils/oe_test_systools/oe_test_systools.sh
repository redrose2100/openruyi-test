#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023.2.17
# @License   :   Mulan PSL v2
# @Desc      :   systool command test
# ############################################
# shellcheck disable=SC1090

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL sysfsutils
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systool -h | grep systool
    CHECK_RESULT $? 0 0 "Systool help display failed"
    systool | grep -E 'buses|classes|devices|modules'
    CHECK_RESULT $? 0 0 "systool information query failed"
    systool -b pci -av | grep pci
    CHECK_RESULT $? 0 0 "Buses information query failed"
    systool -c pps -av | grep pps
    CHECK_RESULT $? 0 0 "classes information query failed"
    systool -m cpufreq -av | grep cpufreq
    CHECK_RESULT $? 0 0 "modules information query failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
