#!/usr/bin/bash
# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   maojintao
# @Contact   :   mjt1220@126.com
# @Date      :   2023/07/26
# @License   :   Mulan PSL v2
# @Desc      :   sysmonitor 网卡监控测试
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "${OET_PATH}/testcases/function-test/pkgs-test/sysmonitor-kmod/common.sh"

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    # 选择业务网卡，TEST_NIC 会自动排除管理网卡 NODE1_NIC
    test_NetPort=$(TEST_NIC 1 | awk '{print $1}')
    if [ -z "${test_NetPort}" ]; then
        LOG_WARN "No spare network interface for netcard monitor test, skip."
        exit 255
    fi
    cp "${sysmonitor_conf:-}" "${sysmonitor_conf}.bak"
    sed -i "/^NETCARD_MONITOR=/ s/=.*/=\"on\"/" "${sysmonitor_conf}"
    cp /etc/sysmonitor/network /etc/sysmonitor/network.bak
    echo "${test_NetPort} UP" >> /etc/sysmonitor/network
    echo "${test_NetPort} DOWN" >> /etc/sysmonitor/network
    PREPARE_DONE=1
    monitor_restart
}

# 测试点的执行
function run_test() {
    ifconfig "${test_NetPort}" down
    ifconfig "${test_NetPort}" 192.168.1.2/16 up

    fn_wait_for_monitor_log_print "${test_NetPort}: device is up" || oe_err "device is up check failed"

    ifconfig "${test_NetPort}" down
    fn_wait_for_monitor_log_print "${test_NetPort}: device is down" || oe_err "device is up check failed"

}

# 后置处理，恢复测试环境
function post_test() {
    # pre_test 未完成环境准备（如无业务网卡直接 skip）时无需恢复
    if [ "${PREPARE_DONE:-0}" != "1" ]; then
        LOG_WARN "Test environment was not prepared, skip restore."
        return 0
    fi
    # 先清除测试时写入的地址，再拉起网卡，避免残留 192.168.1.2/16
    ifconfig "${test_NetPort}" 0 2>/dev/null
    ifconfig "${test_NetPort}" up 2>/dev/null
    mv "${sysmonitor_conf}.bak" "${sysmonitor_conf}"
    mv /etc/sysmonitor/network.bak /etc/sysmonitor/network
    monitor_restart
}

main "$@"
