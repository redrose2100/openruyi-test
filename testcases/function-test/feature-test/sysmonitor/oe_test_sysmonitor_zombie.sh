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
# @Desc      :   sysmonitor 僵尸进程监控测试
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "${OET_PATH}/testcases/function-test/feature-test/sysmonitor/common.sh"

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    cp -a "${ZOMBIE_CONF}" /tmp/zombie
    sed -i "/^ALARM=/ s/=.*/=\"20\"/" "${ZOMBIE_CONF}"
    sed -i "/^RESUME=/ s/=.*/=\"10\"/" "${ZOMBIE_CONF}"
    sed -i "/^PERIOD=/ s/=.*/=\"5\"/" "${ZOMBIE_CONF}"
    zombie_pre
}

# 测试点的执行
function run_test() {
    python ./zombie_make.py 20 10
    sleep 10
    grep "warning.*sysmonitor.*: zombie process count alarm" "${sysmonitor_log:-}"
    grep "info.*sysmonitor.*: zombie process count resume" "${sysmonitor_log}"
    zombie_parent_pid=$(cat /tmp/zombie_parent_pid)
    grep "zombie parent process: pid is \"${zombie_parent_pid}\", args is python" /var/log/messages
    cat "$sysmonitor_log"
}

# 后置处理，恢复测试环境
function post_test() {
    rm -f /tmp/zombie_parent_pid
    mv /tmp/zombie "${ZOMBIE_CONF}"
    zombie_post
}

main "$@"
