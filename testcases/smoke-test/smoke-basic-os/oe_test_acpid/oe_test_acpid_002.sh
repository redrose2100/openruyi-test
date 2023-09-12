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
    grep acpid /var/log/messages | grep "loaded"
    CHECK_RESULT $? 0 0 "load Service failure"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"

