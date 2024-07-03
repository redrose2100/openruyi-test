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
    SLEEP_WAIT 1
    oeawarectl -q | grep "thread_collector(available, running)"
    CHECK_RESULT $? 0 0 "restart oeaware failed"

    \cp -rf /etc/oeAware/config_ori.yaml /etc/oeAware/config.yaml
    systemctl restart oeaware
    SLEEP_WAIT 1
    if [ "$NODE1_FRAME" == "aarch64" ]; then
        sed -i '/enable_list/a\ - name: libthread_scenario.so \n - name: libpmu.so' /etc/oeAware/config.yaml
    else
        sed -i '/enable_list/a\ - name: libthread_scenario.so' /etc/oeAware/config.yaml
    fi
    systemctl restart oeaware
    SLEEP_WAIT 1
    
    if [ "$NODE1_FRAME" == "aarch64" ]; then

        if [ "$NODE1_MACHINE" == "kvm" ]
        then

            oeawarectl -q | grep "pmu_cycles_sampling(available, running)"
            CHECK_RESULT $? 0 0 "Instance running failed"
            oeawarectl -q | grep "pmu_cycles_counting(available, running)"
            CHECK_RESULT $? 0 0 "Instance running failed"
            oeawarectl -q | grep "pmu_spe_sampling(available, close)"
            CHECK_RESULT $? 0 0 "Instance running failed"
            oeawarectl -q | grep "pmu_uncore_counting(available, close)"
            CHECK_RESULT $? 0 0 "Instance running failed"

        else
            oeawarectl -q | grep "available, close"
            CHECK_RESULT $? 1 0 "instances enable failed"
        fi
    else
        oeawarectl -q | grep "thread_collector(available, running)"
        CHECK_RESULT $? 0 0 "Instance running failed"
        oeawarectl -q | grep "thread_scenario(available, running)"
        CHECK_RESULT $? 0 0 "Instance running failed"
    fi

    \cp -rf /etc/oeAware/config_ori.yaml /etc/oeAware/config.yaml
    systemctl restart oeaware
    SLEEP_WAIT 10

    if [ "$NODE1_FRAME" == "aarch64" ]; then
        sed -i '/enable_list/a\ - name: libpmu.so \n   instances:\n     - pmu_cycles_sampling\n     - pmu_cycles_counting' /etc/oeAware/config.yaml
        systemctl restart oeaware
        SLEEP_WAIT 1
        oeawarectl -q | grep "pmu_cycles_sampling(available, running)"
        CHECK_RESULT $? 0 0 "Instance running failed"
        oeawarectl -q | grep "pmu_cycles_counting(available, running)"
        CHECK_RESULT $? 0 0 "Instance running failed"
        oeawarectl -q | grep "pmu_spe_sampling(available, close)"
        CHECK_RESULT $? 0 0 "Instance running failed"
        oeawarectl -q | grep "pmu_uncore_counting(available, close)"
        CHECK_RESULT $? 0 0 "Instance running failed"

        \cp -rf /etc/oeAware/config_ori.yaml /etc/oeAware/config.yaml
        systemctl restart oeaware

        sed -i '/enable_list/a\ - name: libpmu.so\n   instances:\n     - pmu_cycles_sampling\n     - pmu_cycles_counting\n     - pmu_uncore_counting\n     - pmu_spe_sampling' /etc/oeAware/config.yaml
        systemctl restart oeaware
        SLEEP_WAIT 1
        
        if [ "$NODE1_MACHINE" == "kvm" ]
        then
            oeawarectl -q | grep "pmu_cycles_sampling(available, running)"
            CHECK_RESULT $? 0 0 "Instance running failed"
            oeawarectl -q | grep "pmu_cycles_counting(available, running)"
            CHECK_RESULT $? 0 0 "Instance running failed"
            oeawarectl -q | grep "pmu_spe_sampling(available, close)"
            CHECK_RESULT $? 0 0 "Instance running failed"
            oeawarectl -q | grep "pmu_uncore_counting(available, close)"
            CHECK_RESULT $? 0 0 "Instance running failed"
        else
            oeawarectl -q | grep "available, close"
            CHECK_RESULT $? 1 0 "instances enable failed"
        fi

    fi

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    \cp -rf /etc/oeAware/config_ori.yaml /etc/oeAware/config.yaml
    systemctl restart oeaware
    DNF_REMOVE "$@"
    rm -rf /etc/oeAware/config_ori.yaml
    LOG_INFO "End to restore the test environment."
}

main "$@"
