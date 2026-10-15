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
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    git-rebase-theirs -h |grep "Usage: git-rebase-theirs"
    CHECK_RESULT $? 0 0 "L$LINENO: git-rebase-theirs -h No Pass"
    git-rebase-theirs /root/test-tools/test/test-tools/README.md
    CHECK_RESULT $? 0 0 "L$LINENO: git-rebase-theirs No Pass"
    git-rebase-theirs -v /root/test-tools/test/test-tools/README.md
    CHECK_RESULT $? 0 0 "L$LINENO: git-rebase-theirs -v No Pass"
    git-rebase-theirs --in-place /root/test-tools/test/test-tools/README.md
    CHECK_RESULT $? 0 0 "L$LINENO: git-rebase-theirs --in-place No Pass"
    git-rebase-theirs --no-backup /root/test-tools/test/test-tools/README.md
    CHECK_RESULT $? 0 0 "L$LINENO: git-rebase-theirs --no-backup No Pass"
    LOG_INFO "End to run test."
}


function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf ../test-tools
    LOG_INFO "End to restore the test environment."
}

main "$@"
