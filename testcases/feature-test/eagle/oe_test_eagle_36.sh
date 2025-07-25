#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
#@Date          :   2024-07-16
#@License       :   Mulan PSL v2
#@Desc          :   set parameter [mpc_service] enable_mpc test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ! [ "${NODE1_FRAME}" = "aarch64" ] && [ "${NODE1_MACHINE}" = "physical" ]; then
       echo "eagle仅支持aarch64架构和物理机!"
       exit 255
    fi
    echo > /var/log/eagle/eagle.log
    DNF_INSTALL "eagle python3-eagle-mpctool"
    cp /etc/eagle/eagle_policy.ini /etc/eagle/eagle_policy.ini_bak
    sed -i "/\[mpc_service\]/{N;s/.*/[mpc_service]\nenable=1/}" /etc/eagle/eagle_policy.ini
    LOG_INFO "End to to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    if ! ipmitool raw 0x30 0x92 0xdb 0x07 0x00 0x27 0x01 0x01 2>&1 | grep -E "Unable to send RAW command|Could not open device"; then
        sed -i 's/enable_mpc =.*/enable_mpc = 1/' /etc/eagle/eagle_policy.ini
        SLEEP_WAIT 5
        systemctl status mpctool.service | grep "Active: active"
        CHECK_RESULT $? 0 0 "Check mpctool.service enable failed"
        sed -i 's/enable_mpc =.*/enable_mpc = 0/' /etc/eagle/eagle_policy.ini
        SLEEP_WAIT 5
        systemctl status mpctool.service | grep "Active: inactive"
        CHECK_RESULT $? 0 0 "Check mpctool.service disable failed"
    fi
    sed -i 's/enable_mpc =.*/enable_mpc = -1/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep -F "Policy Content Error: seg:[mpc_service] item:enable_mpc value:-1" /var/log/eagle/eagle.log
    CHECK_RESULT $? 0 0 "Check Error: seg:[mpc_service] item:enable_mpc value failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f /etc/eagle/eagle_policy.ini_bak /etc/eagle/eagle_policy.ini
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
