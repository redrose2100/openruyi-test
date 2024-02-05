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
    cd ./test-tools || exit
    git init
    git branch test
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    git-restore-mtime -h | grep "usage: git-restore-mtime"
    CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime -h No Pass"
    git-restore-mtime 2>&1 | grep "in work dir"
    CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime No Pass"
    git-restore-mtime -q
    CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime -q No Pass"
    git-restore-mtime -v 2>&1 | grep "Statistics"
    CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime -v No Pass"
    git-restore-mtime -f 2>&1 | grep "in work dir"
    CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime -f No Pass"
    git-restore-mtime -m 2>&1 | grep "in work dir"
    CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime -m No Pass"
    git-restore-mtime --first-parent 2>&1 | grep "in work dir"
    CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime --first-parent No Pass"
    git-restore-mtime -s 2>&1 | grep "in work dir"
    CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime -s No Pass"
    git-restore-mtime -D 2>&1 | grep "in work dir"
    CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime -D No Pass"
    git-restore-mtime -t 2>&1 | grep "in work dir"
    CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime -t No Pass"
    git-restore-mtime -c 2>&1 | grep "in work dir"
    CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime -c No Pass"
    git-restore-mtime --work-tree . 2>&1 | grep "in work dir"
    CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime --work-tree No Pass"
    git-restore-mtime --git-dir .git 2>&1 | grep "in work dir"
    CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime No Pass"
    LOG_INFO "End to run test."
}


function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf ../test-tools
    LOG_INFO "End to restore the test environment."
}

main "$@"
