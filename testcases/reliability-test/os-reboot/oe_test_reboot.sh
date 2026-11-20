#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   doraemon2020
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-09
# @License   :   Mulan PSL v2
# @Desc      :   Reboot test
# ############################################
# shellcheck disable=SC2034,SC2119,SC1091
source "./common_reboot.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    EXECUTE_T="150m"
    # The openRuyi image does not preinstall openssh-clients, and SSH_CMD is implemented
    # through the expect-wrapped ssh, so every call fails with
    # 'couldn't execute "ssh": no such file or directory' when the package is missing.
    DNF_INSTALL "dmidecode openssh-clients"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    repet_num=0
    while [ ${repet_num} -le 50 ]; do
        echo "===========loop ${repet_num}=============="
        SSH_CMD "ls" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
        CHECK_RESULT $?

        SSH_CMD "reboot" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

        # A graceful reboot can take longer than 10s to drop the link, so poll for the
        # node going down instead of using the previous fixed-window
        # "ping -c 10 + grep '0% packet loss'" probe.
        WAIT_NODE_DOWN 2 120
        CHECK_RESULT $? 0 0 "The execution of the 'reboot' command failed."

        REMOTE_REBOOT_WAIT 2 120
        CHECK_RESULT $?
        ((repet_num++))
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf lossfile
    LOG_INFO "End to restore the test environment."
}

main "$@"
