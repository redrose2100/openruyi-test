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
# @Desc      :   libssh2 SSH connection and authentication API test
# ############################################
# shellcheck disable=SC1091
source "./common_libssh2.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

	# Step 1: Prepare test environment
    env_prepare

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # Step 2: Create SSH API test program source file
    cat > test_ssh_api.c << 'EOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libssh2.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main(int argc, char *argv[]) {
    int rc;
    int sock;
    struct sockaddr_in sin;
    LIBSSH2_SESSION *session = NULL;
    const char *host = "127.0.0.1";
    const char *user = "testuser";
    const char *passwd = "openEuler12#$";
    
    rc = libssh2_init(0);
    if (rc != 0) {
        printf("libssh2_init failed: %d\n", rc);
        printf("RESULT: SKIP\n");
        return 0;
    }
    
    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) {
        printf("socket creation failed\n");
        printf("RESULT: SKIP\n");
        libssh2_exit();
        return 0;
    }
    
    sin.sin_family = AF_INET;
    sin.sin_port = htons(22);
    sin.sin_addr.s_addr = inet_addr(host);
    
    rc = connect(sock, (struct sockaddr*)&sin, sizeof(sin));
    if (rc != 0) {
        printf("connect failed\n");
        printf("RESULT: SKIP\n");
        close(sock);
        libssh2_exit();
        return 0;
    }
    
    session = libssh2_session_init();
    if (!session) {
        printf("libssh2_session_init failed\n");
        printf("RESULT: SKIP\n");
        close(sock);
        libssh2_exit();
        return 0;
    }
    
    rc = libssh2_session_handshake(session, sock);
    if (rc != 0) {
        printf("libssh2_session_handshake failed: %d\n", rc);
        printf("RESULT: SKIP\n");
        libssh2_session_free(session);
        close(sock);
        libssh2_exit();
        return 0;
    }
    
    rc = libssh2_userauth_password(session, user, passwd);
    if (rc != 0) {
        printf("libssh2_userauth_password failed: %d\n", rc);
        printf("RESULT: SKIP\n");
        libssh2_session_disconnect(session, "Normal Shutdown");
        libssh2_session_free(session);
        close(sock);
        libssh2_exit();
        return 0;
    }
    
    printf("SSH connection and authentication successful\n");
    printf("RESULT: PASS\n");
    
    libssh2_session_disconnect(session, "Normal Shutdown");
    libssh2_session_free(session);
    close(sock);
    libssh2_exit();
    
    return 0;
}
EOF
    CHECK_RESULT $? 0 0 "Failed to create test_ssh_api.c"
    
    # Step 3: Compile SSH API test program
    gcc test_ssh_api.c -o test_ssh_api -lssh2 -lcrypto -lssl -lz
    CHECK_RESULT $? 0 0 "Failed to compile SSH API test program"
    
    # Step 4: Run SSH API test
    ./test_ssh_api | grep "RESULT: PASS"
    CHECK_RESULT $? 0 0 "SSH API test failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
	# Step 5: Clean up test environment, remove temporary files and packages
    rm -f test_ssh_api.c test_ssh_api
    env_clean
    LOG_INFO "End to restore the test environment."
}

main "$@"