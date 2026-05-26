#!/usr/bin/bash
# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under the Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liliqi
# @Contact   :   liliqi@uniontech.com
# @Date      :   2026-05-25
# @License   :   Mulan PSL v2
# @Desc      :   glibc sendfile system call test
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gcc glibc-devel"
    LOG_INFO "End of environmental preparation!"
}

function run_test()
{
    LOG_INFO "start to run test."
    # 实际文件复制功能测试
    cat > test_copy.c << EOF
#include <stdio.h>
#include <fcntl.h>
#include <sys/sendfile.h>
#include <sys/stat.h>
#include <unistd.h>

int main()
{
    int fd_in, fd_out;
    struct stat st;

    fd_in = open("src.txt", O_RDWR | O_CREAT | O_TRUNC, 0644);
    write(fd_in, "sendfile test data", 18);
    close(fd_in);

    fd_in = open("src.txt", O_RDONLY);
    fstat(fd_in, &st);
    fd_out = open("dst.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
    sendfile(fd_out, fd_in, NULL, st.st_size);
    close(fd_in);
    close(fd_out);

    return 0;
}
EOF
    gcc test_copy.c -o test_copy
    ./test_copy
    grep -q "sendfile test data" dst.txt
    CHECK_RESULT $? 0 0 "sendfile file copy failed"

    # sendfile 返回值验证
    cat > test_return.c << EOF
#include <stdio.h>
#include <fcntl.h>
#include <sys/sendfile.h>
#include <sys/stat.h>
#include <unistd.h>

int main()
{
    int fd_in = open("/etc/hosts", O_RDONLY);
    if (fd_in == -1) return 1;

    struct stat st;
    fstat(fd_in, &st);

    int fd_out = open("/tmp/copy_hosts", O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd_out == -1) return 1;

    ssize_t ret = sendfile(fd_out, fd_in, NULL, st.st_size);
    close(fd_in);
    close(fd_out);

    if (ret == st.st_size) {
        printf("sendfile returned correct bytes: %ld\n", ret);
        return 0;
    }
    return 1;
}
EOF
    gcc test_return.c -o test_return
    ./test_return
    CHECK_RESULT $? 0 0 "sendfile return value verification failed"

    # 错误处理测试（无效参数）
    cat > test_error.c << EOF
#include <stdio.h>
#include <sys/sendfile.h>
#include <errno.h>

int main()
{
    errno = 0;
    ssize_t ret = sendfile(-1, -1, NULL, 0);

    if (ret == -1 && errno == EBADF) {
        printf("error handling: EBADF returned correctly\n");
        return 0;
    }
    return 1;
}
EOF
    gcc test_error.c -o test_error
    ./test_error
    CHECK_RESULT $? 0 0 "sendfile error handling failed"

    LOG_INFO "All test executed successfully!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    #shellcheck disable=SC2119
    DNF_REMOVE
    rm -rf test_copy.c test_copy src.txt dst.txt
    rm -rf test_return.c test_return /tmp/copy_hosts
    rm -rf test_error.c test_error
    LOG_INFO "End to restore the test environment."
}

main "$@"
