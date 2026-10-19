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
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    numafast -i 100 > numafast.log &
    pkill -9 numafast
    grep "sampling-interval: 100" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast -i 100 failed"
    numafast -i 100000 > numafast.log &
    pkill -9 numafast
    grep "sampling-interval: 100000" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast -i 100000 failed"
    numafast -i 0 | grep "sampling-interval value out of range, min: 100, max: 100000, current value: 0"
    CHECK_RESULT $? 0 0 "Error: Check numafast -i 0 failed"
    numafast -i  100001 | grep "sampling-interval value out of range, min: 100, max: 100000, current value: 100001"
    CHECK_RESULT $? 0 0 "Error: Check numafast -i 100001 failed"
    numafast -t 1 > numafast.log &
    pkill -9 numafast
    grep "sampling-times: 1" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast -t 1 failed"
    numafast -t 1000 > numafast.log &
    pkill -9 numafast
    grep "sampling-times: 1000" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast -t 1000 failed"
    numafast -t 0 | grep "sampling-times value out of range, min: 1, max: 1000, current value: 0"
    CHECK_RESULT $? 0 0 "Error: Check numafast -t 0 failed"
    numafast -t 1001 | grep "sampling-times value out of range, min: 1, max: 1000, current value: 1001"
    CHECK_RESULT $? 0 0 "Error: Check numafast -t 1001 failed"
    numafast -s 1 > numafast.log &
    pkill -9 numafast
    grep "spe-period: 1" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast -s 1 failed"
    numafast -s 4294967295 > numafast.log &
    pkill -9 numafast
    grep "spe-period: 4294967295" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast -s 4294967295 failed"
    numafast -s 0 | grep "spePeriod value out of range, min: 1, max: 4294967295, current value: 0" 
    CHECK_RESULT $? 0 0 "Error: Check numafast -s 0 failed"
    numafast -s 4294967296 | grep "cmdline error: spe-period should be a unsigned int value but now is 4294967296"
    CHECK_RESULT $? 0 0 "Error: Check numafast -s 4294967296 failed"
    sed -i 's/page-reserve:.*/page-reserve: "0"/' /etc/numafast.yaml
    sed -i 's/min-numa-score:.*/min-numa-score: "0"/' /etc/numafast.yaml
    sed -i 's/max-numa-score:.*/max-numa-score: "0"/' /etc/numafast.yaml
    sed -i 's/min-rx-ops-per-ms:.*/min-rx-ops-per-ms: "0"/' /etc/numafast.yaml
    numafast > numafast.log &
    pkill -9 numafast
    grep "page-reserve: 0" numafast.log && grep "min-numa-score: 0" numafast.log && grep "max-numa-score: 0" numafast.log && grep "min-rx-ops-per-ms: 0" numafast.log 
    CHECK_RESULT $? 0 0 "Error: Check numafast set page-reserve min-numa-score max-numa-score min-rx-ops-per-ms is minimum failed"
    sed -i 's/page-reserve:.*/page-reserve: "4294967295"/' /etc/numafast.yaml
    sed -i 's/min-numa-score:.*/min-numa-score: "1000"/' /etc/numafast.yaml
    sed -i 's/max-numa-score:.*/max-numa-score: "1000"/' /etc/numafast.yaml
    sed -i 's/min-rx-ops-per-ms:.*/min-rx-ops-per-ms: "4294967295"/' /etc/numafast.yaml
    numafast > numafast.log &
    pkill -9 numafast
    grep "page-reserve: 4294967295" numafast.log && grep "min-numa-score: 1000" numafast.log && grep "max-numa-score: 1000" numafast.log && grep "min-rx-ops-per-ms: 4294967295" numafast.log 
    CHECK_RESULT $? 0 0 "Error: Check numafast set page-reserve min-numa-score max-numa-score min-rx-ops-per-ms is maximum failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf numafast.log
    mv -f /etc/numafast.yaml_bak /etc/numafast.yaml
    rpm -e numafast
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
