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
    if ! perf list | grep arm_spe;then
        LOG_INFO "The environment does not support testing"
        exit 255
    fi
    DNF_INSTALL "oeAware-manager"
    systemctl start oeaware
    miss_arr=($(oeawarectl analysis -t 3 | grep tlb_miss | awk -F'|' '{print $3}' | sed 's/%//'))
    l1dtlb_miss_thd=$(echo $(printf "%.6f" $(echo "${miss_arr[0]}" + 0.3 | bc)))
    l1itlb_miss_thd=$(echo $(printf "%.6f" $(echo "${miss_arr[1]}" + 0.3 | bc)))
    l2dtlb_miss_thd=$(echo $(printf "%.6f" $(echo "${miss_arr[2]}" + 0.3 | bc)))  
    l2itlb_miss_thd=$(echo $(printf "%.6f" $(echo "${miss_arr[3]}" + 0.3 | bc)))  
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    oeawarectl analysis --l1-miss-threshold "${l1dtlb_miss_thd}" -t 3 | grep l1dtlb_miss | grep low
    CHECK_RESULT $? 0 0 "Error: set l1dtlb_miss low failed"
    oeawarectl analysis --l1-miss-threshold "${l1itlb_miss_thd}" -t 3 | grep l1itlb_miss | grep low
    CHECK_RESULT $? 0 0 "Error: set l1itlb_miss low failed"
    oeawarectl analysis --l2-miss-threshold "${l2dtlb_miss_thd}" -t 3 | grep l2dtlb_miss | grep low
    CHECK_RESULT $? 0 0 "Error: set l2dtlb_miss low failed"
    oeawarectl analysis --l2-miss-threshold "${l2itlb_miss_thd}" -t 3 | grep l2itlb_miss | grep low
    CHECK_RESULT $? 0 0 "Error: set l2itlb_miss low failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
