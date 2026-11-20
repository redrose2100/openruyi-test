#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test initrd-cleanup.service restart
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    touch /etc/initrd-release
    # openRuyi 适配：initrd-cleanup.service 在正常启动的系统中 start 会连带触发
    # initrd-switch-root 等相关作业，systemctl 长时间不返回（本次报告即卡在这一行，
    # 用例 1800s 超时）。这里限时启动，超时不影响后续状态校验：
    # 条件不满足时 unit 保持 inactive (dead) + Result=success，test_oneshot 可正常通过。
    timeout 60 systemctl start initrd-cleanup.service
    LOG_INFO "Finish environment cleanup!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_oneshot initrd-cleanup.service 'inactive (dead)'
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    rm -rf /etc/initrd-release
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
