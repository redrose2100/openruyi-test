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
    DNF_INSTALL "sysSentry pyxalarm pysentry_notify pysentry_collect"
    cp /etc/sysSentry/collector.conf /etc/sysSentry/collector.conf_bak
    sed -i 's/nvme_ssd_threshold.*/nvme_ssd_threshold=0/' /etc/sysSentry/collector.conf
    echo > /var/log/sysSentry/collector.log
    systemctl restart xalarmd sentryCollector sysSentry
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    grep "module_name = io section, field = nvme_ssd_threshold is incorrect, use default 1000" /var/log/sysSentry/collector.log
    CHECK_RESULT $? 0 0 "Error: Check exception value failed"
    \cp -f /etc/sysSentry/collector.conf_bak /etc/sysSentry/collector.conf
    sed -i 's/nvme_ssd_threshold.*/nvme_ssd_threshold=16.8/' /etc/sysSentry/collector.conf
    echo > /var/log/sysSentry/collector.log
    systemctl restart sentryCollector
    SLEEP_WAIT 3
    grep "module_name = io section, field = nvme_ssd_threshold is incorrect, use default 1000" /var/log/sysSentry/collector.log
    CHECK_RESULT $? 0 0 "Error: Check exception value failed"
    \cp -f /etc/sysSentry/collector.conf_bak /etc/sysSentry/collector.conf
    sed -i 's/nvme_ssd_threshold.*/nvme_ssd_threshold=abc/' /etc/sysSentry/collector.conf
    echo > /var/log/sysSentry/collector.log
    systemctl restart sentryCollector
    SLEEP_WAIT 3
    grep "module_name = io section, field = nvme_ssd_threshold is incorrect, use default 1000" /var/log/sysSentry/collector.log
    CHECK_RESULT $? 0 0 "Error: Check exception value failed"
    \cp -f /etc/sysSentry/collector.conf_bak /etc/sysSentry/collector.conf
    sed -i 's/nvme_ssd_threshold.*/nvme_ssd_threshold=16abc/' /etc/sysSentry/collector.conf
    echo > /var/log/sysSentry/collector.log
    systemctl restart sentryCollector
    SLEEP_WAIT 3
    grep "module_name = io section, field = nvme_ssd_threshold is incorrect, use default 1000" /var/log/sysSentry/collector.log
    CHECK_RESULT $? 0 0 "Error: Check exception value failed"
    \cp -f /etc/sysSentry/collector.conf_bak /etc/sysSentry/collector.conf
    sed -i 's/nvme_ssd_threshold.*/nvme_ssd_threshold=@#$/' /etc/sysSentry/collector.conf
    echo > /var/log/sysSentry/collector.log
    systemctl restart sentryCollector
    SLEEP_WAIT 3
    grep "module_name = io section, field = nvme_ssd_threshold is incorrect, use default 1000" /var/log/sysSentry/collector.log
    CHECK_RESULT $? 0 0 "Error: Check exception value failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f /etc/sysSentry/collector.conf_bak /etc/sysSentry/collector.conf
    systemctl stop xalarmd sentryCollector sysSentry
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
