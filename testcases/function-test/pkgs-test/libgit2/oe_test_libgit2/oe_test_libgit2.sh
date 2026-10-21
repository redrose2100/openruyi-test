#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2024-01-11
# @License   :   Mulan PSL v2
# @Desc      :   libgit2 basic function.
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libgit2 libgit2-devel libssh2-devel gcc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > clone_repo.c << EOF
#include <stdio.h>
#include <git2.h>

int main(int argc, char *argv[]) {
    const char *repo_url = "https://github.com/libgit2/libgit2.git";
    const char *local_path = "/tmp/libgit2_clone";
    int error;
    git_repository *repo = NULL;

    // 初始化libgit2
    error = git_libgit2_init();
    if (error != 0) {
        printf("Could not initialize libgit2\n");
        return -1;
    }

    // 克隆仓库
    error = git_clone(&repo, repo_url, local_path, NULL);
    if (error != 0) {
        printf("Could not clone repository\n");
        return -1;
    }
    printf("Cloned successfully!\n");

    // 清理并关闭库
    git_repository_free(repo);
    git_libgit2_shutdown();
    return 0;
}
EOF
    CHECK_RESULT $? 0 0 "File creation failed"
    gcc -o clone_repo clone_repo.c -lgit2 -lpthread -lm -lssh2 -lz -lcrypto -lssl -lrt -ldl -lrt
    CHECK_RESULT $? 0 0 "Compilation failed"
    test -e clone_repo
    CHECK_RESULT $? 0 0 "Failed to generate executable file"
    ./clone_repo | grep 'Could not initialize libgit2'
    CHECK_RESULT $? 0 0 "Execution failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf clone_repo.c clone_repo
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"