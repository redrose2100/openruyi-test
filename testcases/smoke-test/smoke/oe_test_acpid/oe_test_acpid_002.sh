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
# @Author    :   huzheyuan
# @Contact   :   huzheyuan@uniontech.com
# @Date      :   2023/07/26
# @License   :   Mulan PSL v2
# @Desc      :   Test acpi 
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL acpid
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /etc/acpi/events/ || exit 
    cat << EOF > /etc/acpi/events/my_rule
event=button/power
action=/sbin/shutdown -h now
EOF
    systemctl restart acpid 
    SLEEP_WAIT 3
    systemctl status acpid | grep running  
    CHECK_RESULT $? 0 0 "Start Service failure"
    # 当初的断言依赖 rsyslog 把 acpid 日志写进 /var/log/messages。openRuyi
    # 默认只有 journald，/var/log/messages 可能不存在，于是断言永远失败。
    # 改成先用文件（若存在），否则用 journalctl 确认 acpid 已完成加载。
    if [ -s /var/log/messages ]; then
        grep acpid /var/log/messages | grep -i "load"
        CHECK_RESULT $? 0 0 "load Service failure"
    else
        LOG_WARN "/var/log/messages is empty, fall back to journalctl for acpid logs."
        journalctl -u acpid --no-pager 2>/dev/null | grep -i "load"
        CHECK_RESULT $? 0 0 "load Service failure"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"

