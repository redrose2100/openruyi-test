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
# shellcheck disable=SC2207,SC2005,SC2046

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "oeAware-manager"
    systemctl start oeaware
    l1dtlb_ms=($(oeawarectl analysis -t 3 | grep l1dtlb_miss | awk -F'|' '{print $3}' | sed 's/%//'))
    l1dtlb_miss_thd=$(echo $(printf "%.6f" $(echo "${l1dtlb_ms[0]}" + 0.3 | bc)))
    SLEEP_WAIT 3
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    oeawarectl analysis --l1-miss-threshold "${l1dtlb_miss_thd}" -t 1 | grep l1dtlb_miss | grep "0.000000%.*low"
    CHECK_RESULT $? 0 0 "Error: set l1dtlb_miss -t 1 failed"
    oeawarectl analysis --l1-miss-threshold "${l1dtlb_miss_thd}" -t 100 | grep l1dtlb_miss | grep low
    CHECK_RESULT $? 0 0 "Error: set l1dtlb_miss -t 100 failed"
    oeawarectl analysis --l1-miss-threshold "${l1dtlb_miss_thd}" -t 0 2>&1 | grep "Error: Invalid time value '0'"
    CHECK_RESULT $? 0 0 "Error: set l1dtlb_miss -t 0 failed"
    oeawarectl analysis --l1-miss-threshold "${l1dtlb_miss_thd}" -t 101 2>&1 | grep "Error: Invalid time value '101'"
    CHECK_RESULT $? 0 0 "Error: set l1dtlb_miss -t 101 failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
