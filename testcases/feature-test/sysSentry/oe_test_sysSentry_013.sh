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
    sentryctl reload avg_block_io
    sentryctl start avg_block_io
    echo > /var/log/sysSentry/avg_block_io.log
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl restart sentryCollector
    grep "collect_plugin: client_send_and_recv failed" /var/log/sysSentry/avg_block_io.log
    CHECK_RESULT $? 0 0 "Error: Check sentryCollector restart avg_block_io.log failed"
    systemctl restart xalarmd
    grep "sentryctl: client connect error" /var/log/sysSentry/avg_block_io.log
    CHECK_RESULT $? 0 0 "Error: Check xalarmd restart avg_block_io.log failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop xalarmd sentryCollector sysSentry
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
