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
# @Desc      :   sysmonitor cpu监控测试
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "${OET_PATH}/testcases/feature-test/sysmonitor/common.sh"

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    DNF_INSTALL stress-ng
    true > "${sysmonitor_log:-}"
    # 1 sysmonitor_conf bak
    cp -a "${sysmonitor_conf:-}" "${sysmonitor_conf}".bak
    sed -i "/^CPU_MONITOR=/ s/=.*/=\"on\"/" "${sysmonitor_conf}"
    sed -i "/^CPU_ALARM=/ s/=.*/=\"on\"/" "${sysmonitor_conf}"
    # 2 sysmonitor-cpu bak
    cp -a /etc/sysmonitor/cpu /etc/sysmonitor/cpu.bak
    sed -i "/^MONITOR_PERIOD=/ s/=.*/=\"3\"/" /etc/sysmonitor/cpu
    sed -i "/^STAT_PERIOD=/ s/=.*/=\"3\"/" /etc/sysmonitor/cpu
    diff --color /etc/sysmonitor/cpu.bak /etc/sysmonitor/cpu
    monitor_restart
    pkill -9 stress-ng &> /dev/null
}

# 测试点的执行
function run_test() {
    # 1 stress
    stress_cpu_with_num "0-$(grep -c processor /proc/cpuinfo)" 95
    # 2 alarm
    fn_wait_for_monitor_log_print "CPU usage alarm" || oe_err "[alarm] CPU usage alarm check failed"
    # 3 resume
    pkill -9 stress-ng &> /dev/null
    fn_wait_for_monitor_log_print "CPU usage resume" || oe_err "[alarm] CPU usage resume check failed"

}

# 后置处理，恢复测试环境
function post_test() {
    pkill -9 stress-ng &> /dev/null
    # restore
    mv "${sysmonitor_conf}".bak "${sysmonitor_conf}"
    mv /etc/sysmonitor/cpu.bak /etc/sysmonitor/cpu
    monitor_restart
    dnf -y remove stress stress-ng
}

main "$@"
