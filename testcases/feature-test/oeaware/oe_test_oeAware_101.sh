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
    oeawarectl -e tune_numa_mem_access -cmd "-w c" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check numafast -w failed"
    oeawarectl -d tune_numa_mem_access
    oeawarectl -e tune_numa_mem_access -cmd "--load-way c" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check numafast --load-way failed"
    oeawarectl -d tune_numa_mem_access
    oeawarectl -e tune_numa_mem_access -cmd "--smt off" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check numafast --smt failed"
    oeawarectl -d tune_numa_mem_access
    oeawarectl -e tune_numa_mem_access -cmd "-v" | grep "Instance enabled failed, because show version:"
    CHECK_RESULT $? 0 0 "Error: Check numafast -v failed"
    oeawarectl -d tune_numa_mem_access
    oeawarectl -e tune_numa_mem_access -cmd "--version" | grep "Instance enabled failed, because show version:"
    CHECK_RESULT $? 0 0 "Error: Check numafast --version failed"
    oeawarectl -d tune_numa_mem_access
    oeawarectl -e tune_numa_mem_access -cmd "-W test,top,redisi" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check numafast -W failed"
    oeawarectl -d tune_numa_mem_access
    oeawarectl -e tune_numa_mem_access -cmd "--whitelist test,top,redis" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check numafast --whitelist failed"
    oeawarectl -d tune_numa_mem_access
    oeawarectl -e tune_numa_mem_access -cmd "-b test,top,redis" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check numafast -b failed"
    oeawarectl -d tune_numa_mem_access
    oeawarectl -e tune_numa_mem_access -cmd "--blacklist test,top,redis" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check numafast --blacklist failed"
    oeawarectl -d tune_numa_mem_access
    oeawarectl -e tune_numa_mem_access -cmd "--precise-load" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check numafast --precise-load failed"
    oeawarectl -d tune_numa_mem_access
    oeawarectl -e tune_numa_mem_access -cmd "--mem-numa-aggregation" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check numafast --mem-numa-aggregation failed"
    oeawarectl -d tune_numa_mem_access
    oeawarectl -e tune_numa_mem_access -cmd "--mem-balance" | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check numafast --mem-balance failed"
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
