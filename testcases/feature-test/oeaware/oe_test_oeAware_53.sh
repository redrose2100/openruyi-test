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
#@Date          :   2025-07-04
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################
# shellcheck disable=SC2046

source "${OET_PATH}"/testcases/feature-test/oeaware/common/common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    pre_nginx
    modprobe smc
    ulimit_old=$(ulimit -a | grep "open files" | awk '{print $4}')
    ulimit -n 65536
    nginx -c /etc/nginx/nginx.conf
    SLEEP_WAIT 3
    old_request=$(wrk -c 2000 -d 60s -t 20 --latency --timeout 5s -H "Connection: keep-alive" https://localhost:20000/index.html | grep "Requests/sec:" | awk -F': ' '{print $2}')
    old_request=$(echo "$old_request" | bc)
    nginx -s quit
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    oeawarectl -e smc_tune | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check smc_tune enable failed"
    nginx -c /etc/nginx/nginx.conf
    SLEEP_WAIT 3
    cur_request=$(wrk -c 2000 -d 60s -t 20 --latency --timeout 5s -H "Connection: keep-alive" https://localhost:20000/index.html | grep "Requests/sec:" | awk -F': ' '{print $2}')
    test $(echo "${cur_request} > ${old_request}" | bc) -eq 1
    CHECK_RESULT $? 0 0 "Error: Check smc_tune enable failed"
    nginx -s quit
    oeawarectl -d smc_tune
    SLEEP_WAIT 3
    cp /etc/oeAware/plugin/smc_acc.yaml /etc/oeAware/plugin/smc_acc.yaml_bak
    sed -i 's/short_connection:.*/short_connection: 0/' /etc/oeAware/plugin/smc_acc.yaml
    oeawarectl -e smc_tune | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check smc_tune enable failed"
    nginx -c /etc/nginx/nginx.conf
    SLEEP_WAIT 3
    cur_request=$(wrk -c 2000 -d 60s -t 20 --latency --timeout 5s -H "Connection: keep-alive" https://localhost:20000/index.html | grep "Requests/sec:" | awk -F': ' '{print $2}')
    test $(echo "${cur_request} > ${old_request}" | bc) -eq 1
    CHECK_RESULT $? 0 0 "Error: Check smc_tune enable failed"
    nginx -s quit
    oeawarectl -d smc_tune
    sed -i 's/short_connection:.*/short_connection: -1/' /etc/oeAware/plugin/smc_acc.yaml
    oeawarectl -e smc_tune | grep "Instance enabled failed, because smc_acc.yaml 'short_connection' value invalid"
    CHECK_RESULT $? 0 0 "Error: Check smc_tune enable failed"
    sed -i 's/short_connection:.*/short_connection: 2/' /etc/oeAware/plugin/smc_acc.yaml
    oeawarectl -e smc_tune | grep "Instance enabled failed, because smc_acc.yaml 'short_connection' value invalid"
    CHECK_RESULT $? 0 0 "Error: Check smc_tune enable failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ulimit -n "${ulimit_old}"
    modprobe -r smc
    mv -f /etc/oeAware/plugin/smc_acc.yaml_bak /etc/oeAware/plugin/smc_acc.yaml
    post_nginx "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
