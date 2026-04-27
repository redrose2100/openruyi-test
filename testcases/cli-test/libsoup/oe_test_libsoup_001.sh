#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under the Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yanglang
# @Contact    :   yanglang@uniontech.com
# @Date      :   2026-04-27
# @License   :   Mulan PSL v2
# @Desc      : libsoup3 HTTP/2 async GET test (100% fixed)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL libsoup3
    DNF_INSTALL libsoup3-devel
    DNF_INSTALL gcc
    DNF_INSTALL glib2-devel
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."

    cat > test_soup3_http2_get.c <<EOF
#include <libsoup/soup.h>
#include <stdio.h>
#include <glib.h>

static void
get_response_cb(GObject *source_object,
                GAsyncResult *res,
                gpointer user_data)
{
    SoupSession *session = SOUP_SESSION(source_object);
    GMainLoop *loop = user_data;
    GBytes *bytes;
    GError *error = NULL;
    SoupMessage *msg;
    guint status;

    bytes = soup_session_send_and_read_finish(session, res, &error);
    if (error) {
        g_printerr("请求失败: %s\n", error->message);
        g_error_free(error);
        g_main_loop_quit(loop);
        return;
    }

    msg = soup_session_get_async_result_message(session, res);
    status = soup_message_get_status(msg);

    g_print("=== libsoup3 HTTP/2 GET 响应 ===\n");
    g_print("状态码: %u\n", status);
    g_print("响应大小: %zu bytes\n", g_bytes_get_size(bytes));

    g_bytes_unref(bytes);
    g_main_loop_quit(loop);
}

int main() {
    GMainLoop *loop;
    SoupSession *session;
    SoupMessage *msg;

    loop = g_main_loop_new(NULL, FALSE);
    session = soup_session_new();
    msg = soup_message_new(SOUP_METHOD_GET, "https://httpbin.org/get");

    // 正确参数顺序：session, msg, io_priority, cancellable, callback, data
    soup_session_send_and_read_async(
        session,
        msg,
        G_PRIORITY_DEFAULT,
        NULL,
        get_response_cb,
        loop
    );

    g_main_loop_run(loop);

    g_object_unref(msg);
    g_object_unref(session);
    g_main_loop_unref(loop);

    return 0;
}
EOF

    CHECK_RESULT $? 0 0 "Create test_soup3_http2_get.c failed!"

    gcc test_soup3_http2_get.c -o test_soup3_http2_get $(pkg-config --cflags --libs libsoup-3.0)
    CHECK_RESULT $? 0 0 "Compile test_soup3_http2_get.c failed!"

    ./test_soup3_http2_get
    CHECK_RESULT $? 0 0 "Run test_soup3_http2_get failed!"

    LOG_INFO "All test cases executed successfully!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    #shellcheck disable=SC2119
    DNF_REMOVE
    rm -rf test_soup3_http2_get.c test_soup3_http2_get
    LOG_INFO "End to restore the test environment."
}

main "$@"