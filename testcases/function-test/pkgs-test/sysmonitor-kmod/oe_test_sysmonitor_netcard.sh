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

# shellcheck disable=SC2010
test_NetPort="$(ls /sys/class/net | grep -v lo | tail -1)"

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    cp "${sysmonitor_conf:-}" "${sysmonitor_conf}.bak"
    sed -i "/^NETCARD_MONITOR=/ s/=.*/=\"on\"/" "${sysmonitor_conf}"
    cp /etc/sysmonitor/network /etc/sysmonitor/network.bak
    echo "${test_NetPort} UP" >> /etc/sysmonitor/network
    echo "${test_NetPort} DOWN" >> /etc/sysmonitor/network
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
    ifconfig "${test_NetPort}" 0 up
    ifconfig "${test_NetPort}"
    mv "${sysmonitor_conf}.bak" "${sysmonitor_conf}"
    mv /etc/sysmonitor/network.bak /etc/sysmonitor/network
    monitor_restart
}

main "$@"
