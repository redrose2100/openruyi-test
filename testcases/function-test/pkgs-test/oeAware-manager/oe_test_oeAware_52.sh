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

source "${OET_PATH}"/testcases/function-test/pkgs-test/oeAware-manager/common/common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "oeAware-manager"
    systemctl restart oeaware
    modprobe smc
    cp /etc/oeAware/analysis_config.yaml /etc/oeAware/analysis_config.yaml_bak
    change_rate_thd1=0
    local_net_flow_thd1=0
    change_rate_thd2=-1
    local_net_flow_thd2=-1
    sed -i "s/change_rate:.*/change_rate: ${change_rate_thd1}/" /etc/oeAware/analysis_config.yaml
    sed -i "s/local_net_flow:.*/local_net_flow: ${local_net_flow_thd1}/" /etc/oeAware/analysis_config.yaml
    SLEEP_WAIT 3
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    oeawarectl analysis -t 3 > analysis.log 2>&1
    change_rate=$(grep SmcDTcpChangeRate analysis.log | awk -F'|' '{print $3}' | sed 's/%//')
    change_rate=$(echo "$change_rate" | bc)
    local_net_flow=$(grep LocalNetFlow analysis.log | awk -F'|' '{print $3}' | sed 's#(MB/s)##')
    local_net_flow=$(echo "$local_net_flow" | bc)
    if [ "${change_rate}" -eq "${change_rate_thd1}" ] && [ "${local_net_flow}" -eq "${local_net_flow_thd1}" ];then
        grep -A2 SmcDTcpChangeRate analysis.log | grep -c high | grep 2
        CHECK_RESULT $? 0 0 "Error: Check set change_rate and local_net_flow threshold=0 failed"
    fi
    sed -i "s/change_rate:.*/change_rate: ${change_rate_thd2}/" /etc/oeAware/analysis_config.yaml
    sed -i "s/local_net_flow:.*/local_net_flow: ${local_net_flow_thd2}/" /etc/oeAware/analysis_config.yaml
    SLEEP_WAIT 3
    oeawarectl analysis -t 3 > analysis.log 2>&1
    grep "analysis config 'smc_d_analysis:change_rate(-1)' value must a non-negative number" analysis.log && grep "analysis config 'smc_d_analysis:local_net_flow(-1)' value must a non-negative number" analysis.log
    CHECK_RESULT $? 0 0 "Error: Check set change_rate and local_net_flow threshold=-1 failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf analysis.log
    mv -f /etc/oeAware/analysis_config.yaml_bak /etc/oeAware/analysis_config.yaml
    modprobe -r smc
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
