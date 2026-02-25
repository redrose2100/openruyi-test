#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
#@Date          :   2026-01-19
#@License       :   Mulan PSL v2
#@Desc          :   numafast test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ! [ "${NODE1_FRAME}" = "aarch64" ] && [ "${NODE1_MACHINE}" = "physical" ];then
        LOG_INFO "The environment does not support testing"
        exit 255
    fi
    DNF_INSTALL "sysSentry pyxalarm pysentry_notify pysentry_collect avg_block_io ai_block_io fio"
    systemctl restart xalarmd sentryCollector sysSentry
    cp /etc/sysSentry/plugins/ai_block_io.ini /etc/sysSentry/plugins/ai_block_io.ini_bak
    sed -i 's/win_threshold_latency.*/win_threshold_latency=5/' /etc/sysSentry/plugins/ai_block_io.ini
    sed -i 's/win_threshold_iodump.*/win_threshold_iodump=6/' /etc/sysSentry/plugins/ai_block_io.ini
    echo > /var/log/sysSentry/ai_block_io.log
    sentryctl reload ai_block_io
    sentryctl start ai_block_io
    SLEEP_WAIT 3
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    grep "'win_threshold_latency': 5, 'win_threshold_iodump': 6" /var/log/sysSentry/ai_block_io.log
    CHECK_RESULT $? 0 0 "Error: Check config failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f /etc/sysSentry/plugins/ai_block_io.ini_bak /etc/sysSentry/plugins/ai_block_io.ini
    systemctl stop xalarmd sentryCollector sysSentry
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
