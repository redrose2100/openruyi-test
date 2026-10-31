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
# @Desc      :   sysmonitor 关键进程监控测试
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "${OET_PATH}/testcases/function-test/pkgs-test/sysmonitor-kmod/common.sh"

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    DNF_INSTALL "diffutils"
    recover_file=$(grep "MONITOR_COMMAND=" /etc/sysmonitor/process/cron | awk -F "=" '{print $2}')
    cp -a "${recover_file}" "${recover_file}.bak"
    chmod 777 "${recover_file}"
    sed '2 isleep 3' -i "${recover_file}"
    diff --color "${recover_file}.bak" "${recover_file}"
}

# 测试点的执行
function run_test() {
    kill -9 "$(pidof crond)"
    fn_wait_for_monitor_log_print "crond is recovered" || oe_err "crond check failed"
    sleep 40
    pgrep -a crond || oe_err "crond is not started"
}

# 后置处理，恢复测试环境
function post_test() {
    mv "${recover_file}.bak" "${recover_file}"
    monitor_restart
}

main "$@"
