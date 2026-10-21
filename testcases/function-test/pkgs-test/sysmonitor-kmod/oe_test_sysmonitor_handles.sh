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
# @Desc      :   sysmonitor 系统句柄监控测试
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "${OET_PATH}/testcases/function-test/pkgs-test/sysmonitor-kmod/common.sh"

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    cp -a "${sysmonitor_conf:-}" "${sysmonitor_conf}".bak
    sed -i "/^FDCNT_MONITOR=/ s/=.*/=\"on\"/" "${sysmonitor_conf}"
    diff --color "${sysmonitor_conf}".bak "${sysmonitor_conf}"

    cp -a /etc/sysmonitor/sys_fd_conf /tmp/sys_fd_conf
    sed -i "/^SYS_FD_ALARM=/ s/=.*/=\"40\"/" /etc/sysmonitor/sys_fd_conf
    sed -i "/^SYS_FD_RESUME=/ s/=.*/=\"40\"/" /etc/sysmonitor/sys_fd_conf
    diff --color /tmp/sys_fd_conf /etc/sysmonitor/sys_fd_conf

    monitor_restart
}

# 测试点的执行
function run_test() {
    info_count=$(grep -c "system fd num monitor: configuration illegal,use default value" "${sysmonitor_log:-}")
    [ "$info_count" -eq 1 ] || oe_err "config check failed"
    grep "system fd num monitor" "${sysmonitor_log}"
}

# 后置处理，恢复测试环境
function post_test() {
    mv "${sysmonitor_conf}".bak "${sysmonitor_conf}"
    mv /tmp/sys_fd_conf /etc/sysmonitor/sys_fd_conf
    monitor_restart
}

main "$@"
