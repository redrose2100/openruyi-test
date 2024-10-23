#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   buchengjie
# @Contact   :   1241427943@qq.com
# @Date      :   2022/10/5
# @License   :   Mulan PSL v2
# @Desc      :   Test "git-tools" command
# ##################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test(){
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "git-tools git"
    git clone https://gitee.com/openeuler/test-tools
    cd  ./test-tools || exit
    git config --local user.email "test@example.com"
    git config --local user.name "test Name"
    git branch testBranch1
    git branch testBranch2
    git branch testBranch3
    git branch testBranch4
    git checkout testBranch1
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    git-strip-merge -h | grep "Usage: git-strip-merge"
    CHECK_RESULT $? 0 0 "L$LINENO: git-strip-merge -h No Pass"
    git-strip-merge master ./* | grep "delete mode"
    CHECK_RESULT $? 0 0 "L$LINENO: git-strip-merge master No Pass"
    git checkout testBranch2
    git-strip-merge -v master ./* | grep "delete mode"
    CHECK_RESULT $? 0 0 "L$LINENO: git-strip-merge master -v No Pass"
    git checkout testBranch3
    git-strip-merge -M  "testMyDeleteMessage" ./* | grep -E "Already up to date|已经是最新的"
    CHECK_RESULT $? 0 0 "L$LINENO: git-strip-merge -M No Pass"
    git checkout testBranch4
    git-strip-merge -m "testMyCommitMessage" ./* | grep -E "Already up to date|已经是最新的"
    CHECK_RESULT $? 0 0 "L$LINENO: git-strip-merge -m No Pass"
    LOG_INFO "End to run test."
}


function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf ../test-tools
    git config --local --unset user.email
    git config --local --unset user.name
    LOG_INFO "End to restore the test environment."
}

main "$@"
