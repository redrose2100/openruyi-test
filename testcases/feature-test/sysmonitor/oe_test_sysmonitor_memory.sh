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
# @Desc      :   sysmonitor 内存监控测试
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "${OET_PATH}/testcases/feature-test/sysmonitor/common.sh"

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    DNF_INSTALL stress-ng
    mem_prefun
    pressure_clear
    DNF_INSTALL "stress-ng"
}

# 测试点的执行
function run_test() {
    stress_mem 95
    fn_wait_for_monitor_log_print "memory usage alarm" || oe_err "[monitor] alarm check failed"

    free -m
    pressure_clear
    echo 3 > /proc/sys/vm/drop_caches
    fn_wait_for_monitor_log_print "memory usage resume" || oe_err "[monitor] resume check failed"
}

# 后置处理，恢复测试环境
function post_test() {
    grep "msg:memory usage" "${sysmonitor_log:-}"
    pressure_clear
    mem_postfun
    DNF_REMOVE "$@"
}

main "$@"
