#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhujinlong
# @Contact   :   zhujinlong@163.com
# @Date      :   2026-07-14
# @License   :   Mulan PSL v2
# @Desc      :   libssh2 common functions
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"
# Prepare test environment for libssh2
# Installs required dependencies, starts SSH server, and sets up test user
function env_prepare() {
	# Step 1: Prepare test environment, install dependencies
	DNF_INSTALL "libssh2 libssh2-devel gcc openssh-server"

	# Step 2: Check if SSH server is running, start if not
	if ! systemctl is-active --quiet sshd; then
		systemctl start sshd
	fi
	SLEEP_WAIT 3

	# Step 3: Verify SSH server is running, skip if not available
	if ! systemctl is-active --quiet sshd; then
		LOG_INFO "SSH server is not running. Skipping this test case."
		exit 255
	fi

	# Step 4: Create test user for SCP test
	if ! id testuser; then
		useradd -m testuser
		echo 'testuser:openEuler12#$' | chpasswd
	fi
}

function env_clean() {
	userdel -rf testuser
	DNF_REMOVE
}
