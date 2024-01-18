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
    cat <<EOF > test.txt
    test command "git-find-uncommitted-repos"
EOF
    git add .
    cd ..
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    git-find-uncommitted-repos -h | grep "Usage: git-find-uncommitted-repos"
    CHECK_RESULT $? 0 0 "L$LINENO: git-find-uncommitted-repos -h No Pass"
    git-find-uncommitted-repos . | grep "./test-tools"
    CHECK_RESULT $? 0 0 "L$LINENO: git-find-uncommitted-repos No Pass"
    git-find-uncommitted-repos -u . | grep "./test-tools"
    CHECK_RESULT $? 0 0 "L$LINENO: git-find-uncommitted-repos -u No Pass"
    LOG_INFO "End to run test."
}


function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf test-tools
    LOG_INFO "End to restore the test environment."
}

main "$@"
