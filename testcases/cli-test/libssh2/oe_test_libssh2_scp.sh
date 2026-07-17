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
# @Desc      :   libssh2 SCP functionality test
# ############################################
# shellcheck disable=SC1091
source "./common_libssh2.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    # Step 1: Prepare test environment
    env_prepare

    # Step 2: Create test file for SCP upload
    echo "Hello libssh2 SCP test" > /tmp/test_scp_src.txt

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Step 3: Create SCP test program source file
    cat > test_scp.c << 'EOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <libssh2.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/stat.h>

int main(int argc, char *argv[]) {
    int rc;
    int sock;
    struct sockaddr_in sin;
    LIBSSH2_SESSION *session = NULL;
    LIBSSH2_CHANNEL *channel = NULL;
    const char *host = "127.0.0.1";
    const char *user = "testuser";
    const char *passwd = "openEuler12#$";
    const char *local_file = "/tmp/test_scp_src.txt";
    const char *remote_file = "/tmp/test_scp_dst.txt";
    FILE *fp;
    char buffer[1024];
    size_t nread;

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

    fp = fopen(local_file, "rb");
    if (!fp) {
        printf("Failed to open local file\n");
        printf("RESULT: SKIP\n");
        libssh2_session_disconnect(session, "Normal Shutdown");
        libssh2_session_free(session);
        close(sock);
        libssh2_exit();
        return 0;
    }

    struct stat st;
    stat(local_file, &st);

    channel = libssh2_scp_send(session, remote_file, st.st_mode & 0777, st.st_size);
    if (!channel) {
        printf("libssh2_scp_send failed\n");
        printf("RESULT: SKIP\n");
        fclose(fp);
        libssh2_session_disconnect(session, "Normal Shutdown");
        libssh2_session_free(session);
        close(sock);
        libssh2_exit();
        return 0;
    }

    while ((nread = fread(buffer, 1, sizeof(buffer), fp)) > 0) {
        char *ptr = buffer;
        while (nread > 0) {
            rc = libssh2_channel_write(channel, ptr, nread);
            if (rc <= 0) {
                printf("libssh2_channel_write failed: %d\n", rc);
                printf("RESULT: SKIP\n");
                fclose(fp);
                libssh2_channel_close(channel);
                libssh2_channel_free(channel);
                libssh2_session_disconnect(session, "Normal Shutdown");
                libssh2_session_free(session);
                close(sock);
                libssh2_exit();
                return 0;
            }
            ptr += rc;
            nread -= rc;
        }
    }

    fclose(fp);
    libssh2_channel_close(channel);
    libssh2_channel_free(channel);

    printf("SCP file upload successful\n");
    printf("RESULT: PASS\n");

    libssh2_session_disconnect(session, "Normal Shutdown");
    libssh2_session_free(session);
    close(sock);
    libssh2_exit();

    return 0;
}
EOF
    CHECK_RESULT $? 0 0 "Failed to create test_scp.c"

    # Step 4: Compile SCP test program
    gcc test_scp.c -o test_scp -lssh2 -lcrypto -lssl -lz
    CHECK_RESULT $? 0 0 "Failed to compile SCP test program"

    # Step 5: Run SCP test
    ./test_scp | grep "RESULT: PASS"
    CHECK_RESULT $? 0 0 "SCP test failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f test_scp.c test_scp /tmp/test_scp_src.txt /tmp/test_scp_dst.txt
    env_clean
    LOG_INFO "End to restore the test environment."
}

main "$@"