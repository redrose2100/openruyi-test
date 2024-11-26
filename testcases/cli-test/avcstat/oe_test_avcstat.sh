#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   lufei
# @Contact   :   lufei@uniontech.com
# @Date      :   2024/11/26
# @License   :   Mulan PSL v2
# @Desc      :   Test avc statistic tool basic usage
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL libselinux
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    local exp=0
    if getenforce | grep "Disabled"; then
        exp=1
        LOG_WARN "selinux is disabled, the case will not run compeletely"
    fi

    avcstat
    CHECK_RESULT $? $exp 0 "check failed."

    avcstat -c
    CHECK_RESULT $? $exp 0 "-c option check failed."

    avcstat -f /sys/fs/selinux/avc/cache_stats
    CHECK_RESULT $? $exp 0 "-f option check failed"

    avcstat -f /tmp/non-exists
    CHECK_RESULT $? 0 1 "-f option check failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
