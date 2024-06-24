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
#@Date          :   2024-06-06
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "oeAware-manager"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {

    LOG_INFO "Start to run test."
    \cp -rf /etc/oeAware/config.yaml /etc/oeAware/config_ori.yaml
    sed -i '/enable_list/a\ - name: libthread_collector.so' /etc/oeAware/config.yaml
    systemctl restart oeaware
    sleep 1s
    oeawarectl -q | grep "thread_collector(available, running)"
    CHECK_RESULT $? 0 0 "restart oeaware failed"

    \cp -rf /etc/oeAware/config_ori.yaml /etc/oeAware/config.yaml
    systemctl restart oeaware
    sleep 1s
    sed -i '/enable_list/a\ - name: libthread_scenario.so' /etc/oeAware/config.yaml
    sed -i '/enable_list/a\ - name: libpmu.so' /etc/oeAware/config.yaml
    grep "libthread_scenario.so" /etc/oeAware/config.yaml
    CHECK_RESULT $? 0 0 "modify config file failed"
    grep "libpmu.so" /etc/oeAware/config.yaml
    CHECK_RESULT $? 0 0 "modify config file failed"
    systemctl restart oeaware
    sleep 1s
    run_count=$(oeawarectl -q | grep -wo running | wc -l)
    if [ "$run_count" -ne 10 ]; then
        echo "Error: an error occurred during enable"
    fi

    \cp -rf /etc/oeAware/config_ori.yaml /etc/oeAware/config.yaml
    systemctl restart oeaware
    sleep 10s
    sed -i '/enable_list/a\ - name: libpmu.so' /etc/oeAware/config.yaml
    sed -i '/libpmu.so/a\   instances:' /etc/oeAware/config.yaml
    sed -i '/instances/a\     - collector_pmu_sampling' /etc/oeAware/config.yaml
    sed -i '/instances/a\     - collector_pmu_counting' /etc/oeAware/config.yaml
    systemctl restart oeaware
    sleep 1s
    oeawarectl -q | grep "collector_pmu_sampling(available, running)"
    CHECK_RESULT $? 0 0 "Instance running failed"
    oeawarectl -q | grep "collector_pmu_counting(available, running)"
    CHECK_RESULT $? 0 0 "Instance running failed"

    \cp -rf /etc/oeAware/config_ori.yaml /etc/oeAware/config.yaml
    systemctl restart oeaware
    sed -i '/enable_list/a\ - name: libpmu.so' /etc/oeAware/config.yaml
    sed -i '/libpmu.so/a\   instances:' /etc/oeAware/config.yaml
    sed -i '/instances/a\     - collector_pmu_sampling' /etc/oeAware/config.yaml
    sed -i '/instances/a\     - collector_pmu_counting' /etc/oeAware/config.yaml
    sed -i '/instances/a\     - collector_pmu_uncore' /etc/oeAware/config.yaml
    sed -i '/instances/a\     - collector_spe' /etc/oeAware/config.yaml
    systemctl restart oeaware
    sleep 1s
    oeawarectl -q | grep "collector_pmu_sampling(available, running)"
    CHECK_RESULT $? 0 0 "Instance running failed"
    oeawarectl -q | grep "collector_pmu_counting(available, running)"
    CHECK_RESULT $? 0 0 "Instance running failed"
    oeawarectl -q | grep "collector_pmu_uncore(available, running)"
    CHECK_RESULT $? 0 0 "Instance running failed"
    oeawarectl -q | grep "collector_spe(available, running)"
    CHECK_RESULT $? 0 0 "Instance running failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf /etc/oeAware/config_ori.yaml
    LOG_INFO "End to restore the test environment."
}

main "$@"
