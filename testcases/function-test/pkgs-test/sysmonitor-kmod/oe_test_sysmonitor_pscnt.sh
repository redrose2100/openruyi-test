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
# @Desc      :   sysmonitor 进程数监控测试
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "${OET_PATH}/testcases/function-test/pkgs-test/sysmonitor-kmod/common.sh"

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    cp "${sysmonitor_conf:-}" "${sysmonitor_conf}.bak"
    sed -i "/^PSCNT_MONITOR=/ s/=.*/=\"on\"/" "${sysmonitor_conf}"
    monitor_restart
    cp "${PSCNT_CONFIG}" "${PSCNT_CONFIG}.bak"
}

# 测试点的执行
function run_test() {
    ##step 1  PERIOD="a"
    sed -i "/^PERIOD=/ s/=.*/=\"a\"/" "${PSCNT_CONFIG}"
    true > "${sysmonitor_log:-}"
    monitor_restart
    fn_wait_for_monitor_log_print "process count monitor: configuration illegal" || oe_err "illegal check failed"
    #step 2   PERIOD="1600.1"
    sed -i "/^PERIOD=/ s/=.*/=\"1600.1\"/" "${PSCNT_CONFIG}"
    true > "$sysmonitor_log"
    monitor_restart
    fn_wait_for_monitor_log_print "process count monitor: configuration illegal" || oe_err "illegal check failed"

    #step 3   PERIOD="-1"
    sed -i "/^PERIOD=/ s/=.*/=\"-1\"/" "${PSCNT_CONFIG}"
    true > "$sysmonitor_log"
    monitor_restart
    fn_wait_for_monitor_log_print "process count monitor: configuration illegal" || oe_err "illegal check failed"

    #step 4  PERIOD="0"
    sed -i "/^PERIOD=/ s/=.*/=\"0\"/" "${PSCNT_CONFIG}"
    true > "$sysmonitor_log"
    monitor_restart
    fn_wait_for_monitor_log_print "process count monitor: configuration illegal" || oe_err "illegal check failed"
}

# 后置处理，恢复测试环境
function post_test() {
    mv "${PSCNT_CONFIG}.bak" "${PSCNT_CONFIG}"
    mv "${sysmonitor_conf}.bak" "${sysmonitor_conf}"
    monitor_restart
}

main "$@"
