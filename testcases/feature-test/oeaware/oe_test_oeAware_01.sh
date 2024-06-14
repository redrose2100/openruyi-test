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
#@Author        :   linqian
#@Contact       :   1179362010@qq.com
#@Date          :   2024-06-04
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "oeAware-manager"
    DNF_INSTALL "numactl"
    systemctl daemon-reload
    systemctl start oeaware
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    oeawarectl --help | grep -F "usage: oeawarectl [options]"
    CHECK_RESULT $? 0 0 "Failed command: oeawarectl --help"
    oeawarectl -q | grep "Show plugins and instances status"
    CHECK_RESULT $? 0 0 "Failed command: oeawarectl -q"
    oeawarectl --list | grep "Plugin list as follows"
    CHECK_RESULT $? 0 0 "Failed command: oeawarectl --list"

    oeawarectl -i numafast | grep "numafast"
    CHECK_RESULT $? 0 0 "Failed command: oeawarectl -i|--install"

    oeawarectl -e thread_scenario | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Instance enabled failed"
    oeawarectl -e collector_pmu_sampling | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Instance enabled failed"
    oeawarectl -e collector_pmu_counting | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Instance enabled failed"
    oeawarectl -e collector_pmu_uncore | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Instance enabled failed"
    oeawarectl -e collector_spe | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Instance enabled failed"
    oeawarectl -e thread_collector | grep "Instance enabled failed, because instance is already enabled"
    CHECK_RESULT $? 0 0 "Instance enabled failed"
    oeawarectl -q | grep "thread_scenario(available, running)"
    CHECK_RESULT $? 0 0 "Instance running failed"
    oeawarectl -q | grep "collector_pmu_sampling(available, running)"
    CHECK_RESULT $? 0 0 "Instance running failed"
    oeawarectl -q | grep "collector_pmu_counting(available, running)"
    CHECK_RESULT $? 0 0 "Instance running failed"
    oeawarectl -q | grep "collector_pmu_uncore(available, running)"
    CHECK_RESULT $? 0 0 "Instance running failed"
    oeawarectl -q | grep "collector_spe(available, running)"
    CHECK_RESULT $? 0 0 "Instance running failed"
    oeawarectl -q | grep "thread_collector(available, running)"
    CHECK_RESULT $? 0 0 "Instance running failed"
    
    oeawarectl -d thread_scenario | grep "Instance disabled successfully"
    CHECK_RESULT $? 0 0 "Instance disabled failed"
    oeawarectl -d collector_pmu_sampling | grep "Instance disabled successfully"
    CHECK_RESULT $? 0 0 "Instance disabled failed"
    oeawarectl -d collector_pmu_counting | grep "Instance disabled successfully"
    CHECK_RESULT $? 0 0 "Instance disabled failed"
    oeawarectl -d collector_pmu_uncore | grep "Instance disabled successfully"
    CHECK_RESULT $? 0 0 "Instance disabled failed"
    oeawarectl -d collector_spe | grep "Instance disabled successfully"
    CHECK_RESULT $? 0 0 "Instance disabled failed"
    oeawarectl -d thread_collector | grep "Instance disabled successfully"
    CHECK_RESULT $? 0 0 "Instance disabled failed"
    oeawarectl -d thread_collector | grep "Instance disabled failed, because instance is already disabled"
    CHECK_RESULT $? 0 0 "Instance disabled failed"
    oeawarectl -q | grep "thread_scenario(available, close)"
    CHECK_RESULT $? 0 0 "Instance close failed"
    oeawarectl -q | grep "collector_pmu_sampling(available, close)"
    CHECK_RESULT $? 0 0 "Instance close failed"
    oeawarectl -q | grep "collector_pmu_counting(available, close)"
    CHECK_RESULT $? 0 0 "Instance close failed"
    oeawarectl -q | grep "collector_pmu_uncore(available, close)"
    CHECK_RESULT $? 0 0 "Instance close failed"
    oeawarectl -q | grep "collector_spe(available, close)"
    CHECK_RESULT $? 0 0 "Instance close failed"
    oeawarectl -q | grep "thread_collector(available, close)"
    CHECK_RESULT $? 0 0 "Instance close failed"
    LOG_INFO "End to run test."
    }

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rpm -e numafast
    LOG_INFO "End to restore the test environment."
}

main "$@"
