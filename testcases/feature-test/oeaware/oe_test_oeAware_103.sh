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
    numafast -h cmd | grep -F "Usage: numafast [options][<param>]"
    CHECK_RESULT $? 0 0 "Error: Check numafast -h cmd failed"
    numafast --help cmd | grep -F "Usage: numafast [options][<param>]"
    CHECK_RESULT $? 0 0 "Error: Check numafast --help cmd failed"
    numafast -h yaml | grep "Usage: vim /etc/numafast.yaml and set options"
    CHECK_RESULT $? 0 0 "Error: Check numafast -h yaml failed"
    numafast --help yaml | grep "Usage: vim /etc/numafast.yaml and set options"
    CHECK_RESULT $? 0 0 "Error: Check numafast --help yaml failed"
    numafast -i 200 > numafast.log &
    SLEEP_WAIT 3
    pkill -9 numafast
    grep "sampling-interval: 200" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast -i failed"
    numafast --sampling-interval 300 > numafast.log &
    SLEEP_WAIT 3
    pkill -9 numafast
    grep "sampling-interval: 300" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast -sampling-interval failed"
    numafast -t 10 > numafast.log &
    SLEEP_WAIT 3
    pkill -9 numafast
    grep "sampling-times: 10" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast -t failed"
    numafast --sampling-times 15 > numafast.log &
    SLEEP_WAIT 3
    pkill -9 numafast
    grep "sampling-times: 15" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast --sampling-times failed"
    numafast -s 512 > numafast.log &
    SLEEP_WAIT 3
    pkill -9 numafast
    grep "spe-period: 512" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast -s failed"
    numafast --spe-period 1024 > numafast.log &
    SLEEP_WAIT 3
    pkill -9 numafast
    grep "spe-period: 1024" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast --spe-period failed"
    numafast -l trace > numafast.log &
    SLEEP_WAIT 3
    pkill -9 numafast
    grep "TRACE" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast -l failed"
    numafast --log-level trace > numafast.log &
    SLEEP_WAIT 3
    pkill -9 numafast
    grep "TRACE" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast --log-level failed"
    numafast -m t > numafast.log &
    SLEEP_WAIT 3
    pkill -9 numafast
    grep "tune-mode: t" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast -m failed"
    numafast --tune-mode t > numafast.log &
    SLEEP_WAIT 3
    pkill -9 numafast
    grep "tune-mode: t" numafast.log
    CHECK_RESULT $? 0 0 "Error: Check numafast --tune-mode failed"
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
