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
#@Date          :   2025-09-15
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if [ "${NODE1_FRAME}" != "aarch64" ]; then
        LOG_INFO "The environment does not support testing"
        exit 255
    fi
    DNF_INSTALL "oeAware-manager numactl"
    systemctl restart oeaware
    oeawarectl -i numafast
    cp /etc/numafast.yaml /etc/numafast.yaml_bak
    cp /etc/oeAware/config.yaml /etc/oeAware/config.yaml_bak
    sed -i 's/log_level:.*/log_level: 0/' /etc/oeAware/config.yaml
    oeawarectl --reload-conf
    echo > /var/log/oeAware/server.log
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    sed -i 's/min-numa-score:.*/min-numa-score: "990"/' /etc/numafast.yaml
    sed -i 's/max-numa-score:.*/max-numa-score: "1000"/' /etc/numafast.yaml
    sed -i 's/min-rx-ops-per-ms:.*/min-rx-ops-per-ms: "0"/' /etc/numafast.yaml
    oeawarectl -e tune_numa_mem_access
    SLEEP_WAIT 5
    grep "should tune: 1" /var/log/oeAware/server.log
    CHECK_RESULT $? 0 0 "Error: Check in-rx-ops-per-ms: 0 failed"
    oeawarectl -d tune_numa_mem_access
    SLEEP_WAIT 5
    sed -i 's/min-numa-score:.*/min-numa-score: "990"/' /etc/numafast.yaml
    sed -i 's/max-numa-score:.*/max-numa-score: "1000"/' /etc/numafast.yaml
    sed -i 's/min-rx-ops-per-ms:.*/min-rx-ops-per-ms: "1000"/' /etc/numafast.yaml
    echo > /var/log/oeAware/server.log
    oeawarectl -e tune_numa_mem_access
    SLEEP_WAIT 5
    grep "should tune: 0" /var/log/oeAware/server.log
    CHECK_RESULT $? 0 0 "Error: Check min-rx-ops-per-ms: 1000 failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    oeawarectl -d tune_numa_mem_access
    mv -f /etc/numafast.yaml_bak /etc/numafast.yaml
    mv -f /etc/oeAware/config.yaml_bak /etc/oeAware/config.yaml
    rpm -e numafast
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
