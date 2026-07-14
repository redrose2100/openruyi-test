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
# @Desc      :   libssh2 SFTP functionality test
# ############################################
# shellcheck disable=SC1091
source "./common_libssh2.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

	# Step 1: Prepare test environment, install dependencies
    env_prepare
    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # Step 2: Create SFTP test program source file
    cat > test_sftp.c << 'EOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libssh2.h>
#include <libssh2_sftp.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main(int argc, char *argv[]) {
    int rc;
    int sock;
    struct sockaddr_in sin;
    LIBSSH2_SESSION *session = NULL;
    LIBSSH2_SFTP *sftp_session = NULL;
    LIBSSH2_SFTP_HANDLE *sftp_handle = NULL;
    const char *host = "127.0.0.1";
    const char *user = "testuser";
    const char *passwd = "openEuler12#$";
    const char *test_file = "/tmp/test_sftp.txt";
    const char *test_content = "Hello libssh2 SFTP test";
    
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
    
    sftp_session = libssh2_sftp_init(session);
    if (!sftp_session) {
        printf("libssh2_sftp_init failed\n");
        printf("RESULT: SKIP\n");
        libssh2_session_disconnect(session, "Normal Shutdown");
        libssh2_session_free(session);
        close(sock);
        libssh2_exit();
        return 0;
    }
    
    sftp_handle = libssh2_sftp_open(sftp_session, test_file, LIBSSH2_FXF_WRITE | LIBSSH2_FXF_CREAT | LIBSSH2_FXF_TRUNC, LIBSSH2_SFTP_S_IRUSR | LIBSSH2_SFTP_S_IWUSR);
    if (!sftp_handle) {
        printf("libssh2_sftp_open failed\n");
        printf("RESULT: SKIP\n");
        libssh2_sftp_shutdown(sftp_session);
        libssh2_session_disconnect(session, "Normal Shutdown");
        libssh2_session_free(session);
        close(sock);
        libssh2_exit();
        return 0;
    }
    
    rc = libssh2_sftp_write(sftp_handle, test_content, strlen(test_content));
    if (rc <= 0) {
        printf("libssh2_sftp_write failed: %d\n", rc);
        printf("RESULT: SKIP\n");
        libssh2_sftp_close_handle(sftp_handle);
        libssh2_sftp_shutdown(sftp_session);
        libssh2_session_disconnect(session, "Normal Shutdown");
        libssh2_session_free(session);
        close(sock);
        libssh2_exit();
        return 0;
    }
    
    libssh2_sftp_close_handle(sftp_handle);
    libssh2_sftp_shutdown(sftp_session);
    
    printf("SFTP file creation and write successful\n");
    printf("RESULT: PASS\n");
    
    libssh2_session_disconnect(session, "Normal Shutdown");
    libssh2_session_free(session);
    close(sock);
    libssh2_exit();
    
    return 0;
}
EOF
    CHECK_RESULT $? 0 0 "Failed to create test_sftp.c"
    
    # Step 3: Compile SFTP test program
    gcc test_sftp.c -o test_sftp -lssh2 -lcrypto -lssl -lz
    CHECK_RESULT $? 0 0 "Failed to compile SFTP test program"
    
    # Step 4: Run SFTP test
    ./test_sftp | grep -q "RESULT: PASS"
    CHECK_RESULT $? 0 0 "SFTP test failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
	# Step 5: Clean up test environment, remove temporary files and packages
    rm -f test_sftp.c test_sftp /tmp/test_sftp.txt
    env_clean
    LOG_INFO "End to restore the test environment."
}

main "$@"