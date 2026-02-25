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
# shellcheck disable=SC2119,SC2120

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ! [ "${NODE1_FRAME}" = "aarch64" ] && [ "${NODE1_MACHINE}" = "physical" ];then
        LOG_INFO "The environment does not support testing"
        exit 255
    fi
    DNF_INSTALL "sysSentry pyxalarm pysentry_notify pysentry_collect avg_block_io ai_block_io fio"
    disks=$(TEST_DISK "$@")
    local_disk=$(echo "${disks}" | head -n 1)
    mkfs.ext4 -F /dev/"${local_disk}"
    mount /dev/"${local_disk}" /mnt
    mkdir /mnt/test
    cp /etc/sysSentry/collector.conf /etc/sysSentry/collector.conf_bak
    sed -i 's/_threshold.*/_threshold=50/' /etc/sysSentry/collector.conf
    sed -i "s/disk.*/disk=${local_disk}/" /etc/sysSentry/collector.conf
    systemctl restart xalarmd sentryCollector sysSentry
    sentryctl reload ai_block_io
    sentryctl start ai_block_io
    echo > /var/log/sysSentry/ai_block_io_extra.log 
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    fio common/random_io.fio
    grep "SLOW IO" /var/log/sysSentry/ai_block_io_extra.log | grep iops
    CHECK_RESULT $? 0 0 "Error: Check iops failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /mnt/test
    umount /mnt
    mv -f /etc/sysSentry/collector.conf_bak /etc/sysSentry/collector.conf
    systemctl stop xalarmd sentryCollector sysSentry
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
