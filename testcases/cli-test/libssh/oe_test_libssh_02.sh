#!/usr/bin/bash

# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   cherry530
# @Contact   :   707078654@qq.com
# @Date      :   2026/07/13
# @License   :   Mulan PSL v2
# @Desc      :   Test libssh SSH connection and SFTP file transfer
# #############################################
# shellcheck disable=SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libssh"
    mkdir -p /tmp/libssh_test
    # Ensure sshd is running on the remote node
    SSH_CMD "systemctl restart sshd" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /tmp/libssh_test || exit 1

    # Test point 1: Verify SSH basic connection by executing a remote command
    SSH_CMD "echo libssh_connect_ok > /tmp/libssh_connect_marker" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "SSH_CMD failed to connect and execute command on remote node"

    # Verify the remote command produced expected output
    SSH_CMD "grep libssh_connect_ok /tmp/libssh_connect_marker" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "remote command did not produce expected marker output"

    # Test point 2: Upload a file from local to remote via SSH_SCP
    echo "libssh scp upload payload" > /tmp/libssh_test/scp_upload.txt
    SSH_SCP /tmp/libssh_test/scp_upload.txt "${NODE2_USER}"@"${NODE2_IPV4}":/tmp/libssh_scp_remote.txt "${NODE2_PASSWORD}"
    CHECK_RESULT $? 0 0 "SSH_SCP failed to upload file to remote node"

    # Verify uploaded content on the remote node
    SSH_CMD "grep 'libssh scp upload payload' /tmp/libssh_scp_remote.txt" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "uploaded file content does not match on remote node"

    # Test point 3: Download the file back from remote to local via SSH_SCP
    SSH_SCP "${NODE2_USER}"@"${NODE2_IPV4}":/tmp/libssh_scp_remote.txt /tmp/libssh_test/scp_download.txt "${NODE2_PASSWORD}"
    CHECK_RESULT $? 0 0 "SSH_SCP failed to download file from remote node"

    # Verify downloaded content matches the original uploaded content
    grep "libssh scp upload payload" /tmp/libssh_test/scp_download.txt
    CHECK_RESULT $? 0 0 "downloaded file content does not match uploaded content"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/libssh_test
    SSH_CMD "rm -f /tmp/libssh_connect_marker /tmp/libssh_scp_remote.txt" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
