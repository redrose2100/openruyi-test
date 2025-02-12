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
# @Author    :   lemon.higgins
# @Contact   :   lemon.higgins@aliyun.com
# @Date      :   2025-02-12
# @License   :   Mulan PSL v2
# @Desc      :   libgit2 basic function.
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

currentDir=$(
    cd "$(dirname $0)" || exit 1
    pwd
)

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libgit2 libgit2-devel libssh2-devel gcc git"
    mkdir my_git_repo && cd my_git_repo || exit
    git init
    echo "hello" >myfile
    git add .
    git commit -m "Initial commit"
    cd $currentDir || exit
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    gcc -o operate_repo operate_repo.c -lgit2 -lpthread -lm -lssh2 -lz -lcrypto -lssl -lrt -ldl -lrt
    CHECK_RESULT $? 0 0 "Failed to compile."
    test -e operate_repo
    CHECK_RESULT $? 0 0 "Failed to generate executable file."
    ./operate_repo | grep "Commit created successfully."
    CHECK_RESULT $? 0 0 "Failed to clone."
    cd my_git_repo || exit
    git status | grep "nothing to commit, working tree clean"
    CHECK_RESULT $? 0 0 "Failed to commit."
    git log | grep "Add example.txt"
    CHECK_RESULT $? 0 0 "Failed to update git log of message."
    git log | grep "Author: Lisa <lisa@163.com>"
    CHECK_RESULT $? 0 0 "Failed to update git log of Author."
    test -f example.txt
    CHECK_RESULT $? 0 0 "Failed to commit example.txt file into my_git_repo."
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    cd $currentDir || exit
    rm -rf ./my_git_repo ./operate_repo
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
