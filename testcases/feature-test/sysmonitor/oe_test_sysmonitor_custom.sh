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
# @Desc      :   sysmonitor 自定义监控测试
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "${OET_PATH}/testcases/feature-test/sysmonitor/common.sh"

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    cp "${sysmonitor_log:-}" "${sysmonitor_log}.bak"
    sed -i "/^CUSTOM_DAEMON_MONITOR=/ s/=.*/=\"on\"/" "$sysmonitor_log"
    sed -i "/^CUSTOM_PERIODIC_MONITOR=/ s/=.*/=\"on\"/" "$sysmonitor_log"
    diff --color "${sysmonitor_log}.bak" "$sysmonitor_log"
    return 0
}

# 测试点的执行
function run_test() {
    grep "CUSTOM_DAEMON_MONITOR=\"on\"" /etc/sysconfig/sysmonitor || oe_err "CUSTOM_DAEMON_MONITOR=on check failed"
    grep "CUSTOM_PERIODIC_MONITOR=\"on\"" /etc/sysconfig/sysmonitor || oe_err "CUSTOM_PERIODIC_MONITOR=on check failed"
    add_daemon_custommonitor daemon1
    add_periodic_custommonitor periodic1
    sleep 5
    monitor_restart
    sleep 15
    pgrep -a -f daemon1 || oe_err "daemon1 start failed"
    grep -w "type\[daemon\] conf_name\[daemon1\] is added to monitor list" "${sysmonitor_log}" || oe_err "[monitor] add daemon1 check failed"
    grep -w "type\[periodic\] conf_name\[periodic1\] is added to monitor list" "${sysmonitor_log}" || oe_err "[monitor] add periodic1 check failed"
}

# 后置处理，恢复测试环境
function post_test() {
    del_custommonitor daemon1
    del_custommonitor periodic1
    grep "conf_name" "$sysmonitor_log"
    mv "${sysmonitor_log}.bak" "${sysmonitor_log}"
    monitor_restart
}

main "$@"
