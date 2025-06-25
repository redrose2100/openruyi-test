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
# @Desc      :   Halt calls reboot
# #############################################

# shellcheck disable=SC1091
source "./common_reboot.sh"

function run_test() {
    LOG_INFO "Start to run test."
    P_SSH_CMD --node 2 --cmd "sudo halt -p --reboot &"
    SLEEP_WAIT 8
    ping -c 3 "${NODE2_IPV4}" >/dev/null
    CHECK_RESULT $? 0 1 "The execution of the 'halt -p --reboot' command failed."
    REMOTE_REBOOT_WAIT 2 120
    CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
    LOG_INFO "End to run test."
}

main "$@"
