#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2025/06/27
# @License   :   Mulan PSL v2
# @Desc      :   Pressure restart
# #############################################

# shellcheck disable=SC1091
source "./common_reboot.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    P_SSH_CMD --node 2 --cmd "dd if=/dev/zero of=/root/file bs=1024 count=100000000"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    P_SSH_CMD --node 2 --cmd "df -h | grep '100%'"
    CHECK_RESULT $? 0 0 "The execution of the 'df -h' command failed."
    P_SSH_CMD --node 2 --cmd "sudo reboot &"
    CHECK_RESULT $? 0 0 "The execution of the 'reboot' command failed."
    SLEEP_WAIT 30
    REMOTE_REBOOT_WAIT 2 120
    CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    P_SSH_CMD --node 2 --cmd "rm -rf /root/file"
    LOG_INFO "End to restore the test environment."
}

main "$@"
