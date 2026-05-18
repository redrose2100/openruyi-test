#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liuyafei
# @Contact   :   liuyafei@uniontech.com
# @Date      :   2026-05-14
# @License   :   Mulan PSL v2
# @Desc      :   Verify nmcli rejects invalid static IP configuration
# #############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function config_params() {
    LOG_INFO "Start loading data!"
    con_name_1='test_invalid_ip'
    con_name_2='test_invalid_prefix'
    OLD_LANG=${LANG}
    export LANG=en_US.UTF-8
    LOG_INFO "Loading data is complete!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "NetworkManager"
    systemctl start NetworkManager >/dev/null 2>&1
    nmcli con delete "${con_name_1}" >/dev/null 2>&1
    nmcli con delete "${con_name_2}" >/dev/null 2>&1
    rm -rf invalid_ip.log invalid_prefix.log
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    nmcli connection add type ethernet con-name "${con_name_1}" ifname "${NODE1_NIC}" ip4 300.0.2.100/24 gw4 192.0.2.1 >invalid_ip.log 2>&1
    CHECK_RESULT $? 0 1 "nmcli should reject invalid IPv4 address 300.0.2.100/24"
    nmcli con show "${con_name_1}" >/dev/null 2>&1
    CHECK_RESULT $? 0 1 "connection ${con_name_1} must not be created after invalid IPv4 input"

    nmcli connection add type ethernet con-name "${con_name_2}" ifname "${NODE1_NIC}" ip4 192.0.2.100/99 gw4 192.0.2.1 >invalid_prefix.log 2>&1
    CHECK_RESULT $? 0 1 "nmcli should reject invalid prefix length 99"
    nmcli con show "${con_name_2}" >/dev/null 2>&1
    CHECK_RESULT $? 0 1 "connection ${con_name_2} must not be created after invalid prefix input"
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    nmcli con delete "${con_name_1}" >/dev/null 2>&1
    nmcli con delete "${con_name_2}" >/dev/null 2>&1
    rm -rf invalid_ip.log invalid_prefix.log
    DNF_REMOVE
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup."
}

main "$@"
