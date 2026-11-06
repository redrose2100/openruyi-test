#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
###################################
#@Author        :   zengcongwei
#@Contact       :   735811396@qq.com
#@Date          :   2020/5/12
#@License       :   Mulan PSL v2
#@Desc          :   Test "--assumeno" & "-b --best" & "-C,--cacheonly" option, Test "dnf autoremove" command
###################################

source "common/common_dnf.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    DNF_INSTALL vim
    rpm -e vim-enhanced
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dnf --assumeno install tree 2>&1 | grep "Operation aborted"
    CHECK_RESULT $?
    rpm -q tree | grep "package tree is not installed"
    CHECK_RESULT $?
    # dnf5: autoremove prints "Removing:" only when there are orphan packages;
    # on openRuyi vim has no vim-common/vim-enhanced subpackages so nothing is left to autoremove
    dnf autoremove -y 2>&1 | grep -E "Removing:|Nothing to do"
    CHECK_RESULT $?
    rpm -qa | grep "vim-common"
    CHECK_RESULT $? 1 0
    dnf -y --nobest install httpd 2>&1 | grep "Complete!"
    CHECK_RESULT $?
    # dnf5 removed -b/--best; installing httpd again is a no-op
    dnf -y install httpd 2>&1 | grep -E "Nothing to do|already installed"
    CHECK_RESULT $?
    dnf makecache 2>&1 | grep "Metadata cache created"
    CHECK_RESULT $?
    # openRuyi Base repo has no kernel package; use tree for repoquery check
    dnf repoquery tree 2>&1 | grep "^tree-"
    CHECK_RESULT $?
    dnf clean all 2>&1 | grep "Removed"
    CHECK_RESULT $?
    # after clean all, cache-only repoquery reports no cache for the repo
    dnf -C repoquery tree 2>&1 | grep "no cache"
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    DNF_REMOVE 1 httpd
    dnf clean all
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
