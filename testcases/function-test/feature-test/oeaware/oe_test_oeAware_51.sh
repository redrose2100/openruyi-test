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

source "${OET_PATH}"/testcases/function-test/feature-test/oeaware/common/common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    pre_nginx
    modprobe smc
    ulimit_old=$(ulimit -a | grep "open files" | awk '{print $4}')
    ulimit -n 65536
    cp /etc/oeAware/analysis_config.yaml /etc/oeAware/analysis_config.yaml_bak
    change_rate_thd=0.05
    local_net_flow_thd=95
    sed -i "s/change_rate:.*/change_rate: ${change_rate_thd}/" /etc/oeAware/analysis_config.yaml
    sed -i "s/local_net_flow:.*/local_net_flow: ${local_net_flow_thd}/" /etc/oeAware/analysis_config.yaml
    nginx -c /etc/nginx/nginx.conf
    SLEEP_WAIT 5
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    wrk -c 1000 -d 60s -t 20 --latency --timeout 5s -H "Connection: keep-alive" https://localhost:20000/index.html &
    oeawarectl analysis -t 3 > analysis.log 2>&1
    change_rate=$(grep SmcDTcpChangeRate analysis.log | awk -F'|' '{print $3}' | sed 's/%//')
    change_rate=$(echo "$change_rate" | bc)
    local_net_flow=$(grep LocalNetFlow analysis.log | awk -F'|' '{print $3}' | sed 's#(MB/s)##')
    local_net_flow=$(echo "$local_net_flow" | bc)
    if [ $(echo "${change_rate} < ${change_rate_thd}*100" | bc) -eq 1 ] && [ $(echo "${local_net_flow} > ${local_net_flow_thd}" | bc) -eq 1 ];then
        grep "use smc-d" analysis.log
        CHECK_RESULT $? 0 0 "Error: Check suggestion smc-d failed"
    fi
    pkill -9 wrk
    SLEEP_WAIT 3
    wrk -c 2000 -d 60s -t 20 --timeout 5s -H "Connection: close" https://localhost:20000/index.html &
    oeawarectl analysis -t 3 > analysis.log 2>&1
    change_rate=$(grep SmcDTcpChangeRate analysis.log | awk -F'|' '{print $3}' | sed 's/%//')
    change_rate=$(echo "$change_rate" | bc)
    local_net_flow=$(grep LocalNetFlow analysis.log | awk -F'|' '{print $3}' | sed 's#(MB/s)##')
    local_net_flow=$(echo "$local_net_flow" | bc)
    if [ $(echo "${change_rate} > ${change_rate_thd}*100" | bc) -eq 1 ] && [ $(echo "${local_net_flow} > ${local_net_flow_thd}" | bc) -eq 1 ];then
        grep -v "use smc-d" analysis.log
        CHECK_RESULT $? 0 0 "Error: Check no uggestion smc-d failed"
    fi
    pkill -9 wrk
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    nginx -s quit
    ulimit -n "${ulimit_old}"
    rm -rf analysis.log
    mv -f /etc/oeAware/analysis_config.yaml_bak /etc/oeAware/analysis_config.yaml
    post_nginx "$@"
    modprobe -r smc
    LOG_INFO "End to restore the test environment."
}

main "$@"
