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
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-4-9
# @License   :   Mulan PSL v2
# @Desc      :   View information about recent system reboots
# #############################################

# shellcheck disable=SC1091
source "./common_reboot.sh"

function pre_test() {
	LOG_INFO "Start to prepare the test environment."
	# The openRuyi image does not preinstall openssh-clients, and SSH_CMD/SSH_SCP are
	# implemented through the expect-wrapped ssh/scp, so every call fails with
	# 'couldn't execute "ssh": no such file or directory' when the package is missing.
	DNF_INSTALL "openssh-clients"
	LOG_INFO "End to prepare the test environment."
}

function run_test() {
	LOG_INFO "Start to run test."
	SSH_CMD "reboot" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
	WAIT_NODE_DOWN 2 120
	REMOTE_REBOOT_WAIT 2 120
	SSH_CMD "reboot" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
	WAIT_NODE_DOWN 2 120
	REMOTE_REBOOT_WAIT 2 120
	SSH_CMD "reboot" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
	WAIT_NODE_DOWN 2 120
	REMOTE_REBOOT_WAIT 2 120
	SSH_CMD "last reboot > /tmp/rebootlog2" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
	CHECK_RESULT $?
	SSH_SCP "${NODE2_USER}"@"${NODE2_IPV4}":/tmp/rebootlog2 . "${NODE2_PASSWORD}"
	CHECK_RESULT $?
	num_user=$(grep -c 'reboot' rebootlog2)
	test "$num_user" -ge 3
	CHECK_RESULT $?
	LOG_INFO "End to run test."
}

function post_test() {
	LOG_INFO "Start to restore the test environment."
	rm -rf rebootlog2
	DNF_REMOVE
	LOG_INFO "End to restore the test environment."
}

main "$@"
