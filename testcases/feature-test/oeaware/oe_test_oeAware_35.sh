#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   wenjun
#@Contact       :   1009065695@qq.com
#@Date          :   2025-03-25
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "oeAware-manager"
    systemctl restart oeaware
    hugepage_old=$(cat /sys/kernel/mm/transparent_hugepage/enabled)
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    oeawarectl -e transparent_hugepage_tune | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check -e transparent_hugepage_tune failed"
    oeawarectl -q | grep "transparent_hugepage_tune(available, running, count: 1)" && grep -F "[always] madvise never" /sys/kernel/mm/transparent_hugepage/enabled
    CHECK_RESULT $? 0 0 "Error: Check -e transparent_hugepage_tune failed"
    oeawarectl -d transparent_hugepage_tune | grep "Instance disabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check -d transparent_hugepage_tune failed"
    oeawarectl -q | grep "transparent_hugepage_tune(available, close, count: 1)" && grep -F "${hugepage_old}" /sys/kernel/mm/transparent_hugepage/enabled
    CHECK_RESULT $? 0 0 "Error: Check -d transparent_hugepage_tune failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
