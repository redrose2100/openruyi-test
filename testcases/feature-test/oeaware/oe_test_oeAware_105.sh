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
    numafast -i 201.12 | grep "cmdline error: sampling-interval should be a unsigned int value but now is 201.12"
    CHECK_RESULT $? 0 0 "Error: Check numafast -i exception value failed"
    numafast -i abc | grep "cmdline error: sampling-interval should be a unsigned int value but now is abc"
    CHECK_RESULT $? 0 0 "Error: Check numafast -i exception value failed"
    numafast -t 1000000000 | grep "sampling-times value out of range, min: 1, max: 1000, current value: 1000000000"
    CHECK_RESULT $? 0 0 "Error: Check numafast -t exception value failed"
    numafast -t 0 | grep "sampling-times value out of range, min: 1, max: 1000, current value: 0"
    CHECK_RESULT $? 0 0 "Error: Check numafast -t exception value failed"
    numafast -t a | grep "cmdline error: sampling-times should be a unsigned int value but now is a"
    CHECK_RESULT $? 0 0 "Error: Check numafast -t exception value failed"
    numafast -s 0 | grep "spePeriod value out of range, min: 1, max: 4294967295, current value: 0"
    CHECK_RESULT $? 0 0 "Error: Check numafast -s exception value failed"
    numafast -l inff | grep -F "cmdline error: log-level should be in [trace, debug, info, warn, error, fatal], now is inff"
    CHECK_RESULT $? 0 0 "Error: Check numafast -l exception value failed"
    numafast -m a | grep -F "cmdline error: tune-mode should be in [b, t, p], now is a"
    CHECK_RESULT $? 0 0 "Error: Check numafast -m exception value failed"
    numafast -w 1.2 | grep -F "cmdline error: load-way should be in [b, c], now is 1.2"
    CHECK_RESULT $? 0 0 "Error: Check numafast -m exception value failed"
    numafast --smt abc | grep -F "cmdline error: smt should be in [off, phy-first], now is abc"
    CHECK_RESULT $? 0 0 "Error: Check numafast --smt exception value failed"
    numafast --precise-load abc | grep "cmdline not support extra parameter, please check cmdline by help"
    CHECK_RESULT $? 0 0 "Error: Check numafast --precise-load exception value failed"
    numafast --precise-loads | grep "option not found, please check cmdline by help"
    CHECK_RESULT $? 0 0 "Error: Check numafast not exists option failed"
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
