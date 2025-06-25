#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2025/06/27
# @License   :   Mulan PSL v2
# @Desc      :   Reboot common file
# #############################################
# shellcheck disable=SC2001
source "$OET_PATH/libs/locallibs/common_lib.sh"

function build_env() {
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    if [ -z "$NODE2_BMC_IP" ]; then
        exit 1
    fi
    DNF_INSTALL "ipmitool OpenIPMI net-tools"
    test_ip=$(echo "$NODE2_BMC_IP" | sed 's/\.[^.]*$//')
    ifconfig "${NODE1_NIC}":1 "${test_ip}".200/24 broadcast 255.255.255.0 up
    modprobe ipmi_watchdog
    modprobe ipmi_poweroff
    modprobe ipmi_devintf
    modprobe ipmi_msghandler
    modprobe ipmi_si
    systemctl restart ipmievd.service
}

function clean_env() {
    export LANG=${OLD_LANG}
    ifconfig "${NODE1_NIC}":1 "${test_ip}".200/24 broadcast 255.255.255.0 down
    DNF_REMOVE "$@"
    modprobe -r ipmi_watchdog
    modprobe -r ipmi_poweroff
    modprobe -r ipmi_devintf
    modprobe -r ipmi_ssif
    modprobe -r ipmi_si
    modprobe -r ipmi_msghandler
}
main "$@"
