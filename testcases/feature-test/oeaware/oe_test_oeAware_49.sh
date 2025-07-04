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
# shellcheck disable=SC2046

source "${OET_PATH}"/testcases/feature-test/oeaware/common/common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    pre_nginx
    tar xf common/UnixBench5.1.3.tgz -C ./
    cd UnixBench || exit 1
    make all
    old_unixbench=$(./Run -c 1 -c $(nproc) -i 3 | grep -A5 INDEX | grep "Execl Throughput" | awk '{print $5}')
    old_unixbench=$(echo "$old_unixbench" | bc)
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    oeawarectl -e preload_tune | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check preload_tune enable failed"
    cur_unixbench=$(./Run -c 1 -c $(nproc) -i 3 | grep -A5 INDEX | grep "Execl Throughput" | awk '{print $5}')
    cur_unixbench=$(echo "$cur_unixbench" | bc)
    result=$(echo "scale=2;($cur_unixbench / $old_unixbench - 1) * 100" | bc)
    test $(echo "$result <= 1" | bc) -eq 1
    CHECK_RESULT $? 0 0 "Error: Check preload_tune profit failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    cd - || exit 1
    rm -rf UnixBench
    oeawarectl -d preload_tune
    post_nginx "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
