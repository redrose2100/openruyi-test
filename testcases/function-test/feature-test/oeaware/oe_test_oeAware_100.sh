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
    oeawarectl -e tune_numa_mem_access -cmd "-h cmd" | grep "Usage: oeaware -e tune_numa_mem_access -cmd"
    CHECK_RESULT $? 0 0 "Error: Check numafast -h cmd failed"
    oeawarectl -e tune_numa_mem_access -cmd "--help cmd" | grep "Usage: oeaware -e tune_numa_mem_access -cmd"
    CHECK_RESULT $? 0 0 "Error: Check numafast --help cmd failed"
    oeawarectl -e tune_numa_mem_access -cmd "-h off" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check enable tune_numa_mem_access failed"
    oeawarectl -d tune_numa_mem_access | grep "Instance disabled successfully"    
    CHECK_RESULT $? 0 0 "Error: Check disable tune_numa_mem_access failed"
    oeawarectl -e tune_numa_mem_access -cmd "-h yaml" | grep "Usage: vim /etc/numafast.yaml and set options"
    CHECK_RESULT $? 0 0 "Error: Check numafast -h yaml failed"
    oeawarectl -e tune_numa_mem_access -cmd "--help yaml" | grep "Usage: vim /etc/numafast.yaml and set options"
    CHECK_RESULT $? 0 0 "Error: Check numafast --help yaml failed"
    oeawarectl -e tune_numa_mem_access -cmd "-i 200" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check numafast -i failed"
    oeawarectl -d tune_numa_mem_access
    oeawarectl -e tune_numa_mem_access -cmd "--sampling-interval 200" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check numafast -sampling-interval failed"
    oeawarectl -d tune_numa_mem_access
    oeawarectl -e tune_numa_mem_access -cmd "-t 10" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check numafast -t failed"
    oeawarectl -d tune_numa_mem_access
    oeawarectl -e tune_numa_mem_access -cmd "--sampling-times 10" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check numafast --sampling-times failed"
    oeawarectl -d tune_numa_mem_access
    oeawarectl -e tune_numa_mem_access -cmd "-m t" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check numafast -m failed"
    oeawarectl -d tune_numa_mem_access
    oeawarectl -e tune_numa_mem_access -cmd "--tune-mode t" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check numafast --tune-mode failed"
    oeawarectl -d tune_numa_mem_access
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f /etc/numafast.yaml_bak /etc/numafast.yaml
    rpm -e numafast
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
