#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020.05-08
# @License   :   Mulan PSL v2
# @Desc      :   Nmcli configure dynamic IP connection
# ############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"
function config_params() {
    LOG_INFO "Start loading data!"
    con_name='test_con'
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "Loading data is complete!"
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    # 直接在被 NetworkManager 托管且用于联网的 ${NODE1_NIC} 上再建一个 Ethernet 连接，
    # 激活时会抢走原连接并等待 DHCP，实验室环境没有 DHCP 服务时会一直超时；
    # 这里改用独立的 dummy 设备承载测试连接，既能验证 add/up/connected 流程，
    # 又不会影响现有网络配置。dummy 不可用时退回手工地址方式。
    test_con_nic="${con_name}"
    modprobe dummy 2>/dev/null || true
    if nmcli connection add type dummy con-name "${con_name}" ifname "${test_con_nic}" \
        ipv4.method manual ipv4.addresses 192.168.199.10/24 ipv6.method disabled; then
        nmcli con up "${con_name}"
        CHECK_RESULT $?
        nmcli device status | grep "${test_con_nic}" | grep -q "connected"
        CHECK_RESULT $?
        nmcli -g IP4.ADDRESS connection show "${con_name}" | grep "192.168.199.10"
        CHECK_RESULT $?
    else
        # 无 dummy 支持时只创建手工地址的配置，不做激活，避免抢占正在使用的物理网卡
        nmcli connection add type ethernet con-name "${con_name}" ifname "${NODE1_NIC}" \
            ipv4.method manual ipv4.addresses 192.168.199.10/24 ipv6.method disabled | grep successfully
        CHECK_RESULT $?
        nmcli connection show "${con_name}" | grep "${NODE1_NIC}"
        CHECK_RESULT $?
        nmcli -g ipv4.method connection show "${con_name}" | grep "manual"
        CHECK_RESULT $?
    fi
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    nmcli con delete "${con_name}" >/dev/null 2>&1
    true
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup."
}

main "$@"
