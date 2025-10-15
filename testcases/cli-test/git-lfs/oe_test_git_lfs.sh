#!/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhou yi
# @Contact   :   1123678689@qq.com
# @Date      :   2025/04/03
# @License   :   Mulan PSL v2
# @Desc      :   Test git-lfs service
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL git-lfs
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test basic git-lfs commands
    git lfs version | grep "git-lfs"
    CHECK_RESULT $? 0 0 "git-lfs is not installed correctly"

    # Initialize a test repository
    test_repo="test_git_lfs_repo"
    mkdir $test_repo && cd $test_repo || exit 1
    git init
    git lfs install
    CHECK_RESULT $? 0 0 "git lfs install failed"

    # Test tracking a file with LFS
    echo "Test file" > testfile.bin
    git lfs track "*.bin"
    CHECK_RESULT $? 0 0 "git lfs track failed"
    git add .gitattributes testfile.bin
    git commit -m "Add LFS tracked file"
    CHECK_RESULT $? 0 0 "git commit failed"

    # Check if LFS hooks are installed
    grep "filter=lfs" .git/config
    CHECK_RESULT $? 0 0 "LFS hooks not properly installed"

    # Test LFS pull (though no remote, should still work locally)
    git lfs pull
    CHECK_RESULT $? 0 0 "git lfs pull failed"

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    # Remove test repository
    if [ -d "$test_repo" ]; then
        rm -rf "$test_repo"
    fi
    DNF_REMOVE git-lfs
    LOG_INFO "Finish environment cleanup!"
}

main "$@"