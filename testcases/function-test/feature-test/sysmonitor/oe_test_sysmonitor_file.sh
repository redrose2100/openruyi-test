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
# @Desc      :   sysmonitor 文件监控测试
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "${OET_PATH}/testcases/function-test/feature-test/sysmonitor/common.sh"

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    file_monitor_prefun
    dmesg -c > /dev/null
}

# 测试点的执行
function run_test() {
    cp -a "${sysmonitor_list:-}"/file "${sysmonitor_list}"/file.bak
    echo "/home 0x300" >> "${sysmonitor_list}"/file
    monitor_restart
    fn_wait_for_monitor_log_print "file name is .*/home.*, watch event is 0x300" \
        || oe_err "[monitor] file ox300 check failed"

    touch /home/file
    fn_wait_for_monitor_log_print "Subfile.* under .*/home.* was added" \
        || oe_err "[monitor] file added check failed"
}

# 后置处理，恢复测试环境
function post_test() {
    rm -rf /home/file
    mv "${sysmonitor_list}"/file.bak "${sysmonitor_list}"/file
    file_monitor_postfun
    monitor_restart
}

main "$@"
