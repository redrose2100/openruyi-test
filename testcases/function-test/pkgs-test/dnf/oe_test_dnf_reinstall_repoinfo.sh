#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   zengcongwei
# @Contact   :   735811396@qq.com
# @Date      :   2020/5/12
# @License   :   Mulan PSL v2
# @Desc      :   Test "dnf reinstall" & "dnf repoinfo" & "dnf repolist" & "dnf repoquery" & "dnf search" & "dnf upgrade-minimal" command, Test "--repo=<repoid>, --repoid=<repoid>" & "--version" option, Install the same package by two dnf at the same time
# ##################################
# shellcheck disable=SC1091
source "common/common_dnf.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    DNF_INSTALL tree
    add_low_repo
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dnf -y reinstall tree 2>&1 | grep -E "Reinstalling:|Complete!"
    CHECK_RESULT $?
    rpm -q tree | grep "^tree-"
    CHECK_RESULT $?
    dnf remove -y tree 2>&1 | grep -E "Removing:|Complete!"
    CHECK_RESULT $?
    # dnf5: reinstalling a not-installed package reports "Packages for argument 'tree' available, but not installed."
    dnf reinstall -y tree 2>&1 | grep "available, but not installed"
    CHECK_RESULT $?
    # openRuyi has no "everything" repository; test the --repo/--repoid option with the Base repository
    dnf --repo=Base repolist 2>&1 | grep "Base"
    CHECK_RESULT $?
    ret=$(dnf --repo=Base repolist 2>&1 | wc -l)
    CHECK_RESULT "$ret" 2 0
    dnf --repoid=Base repolist 2>&1 | grep "Base"
    CHECK_RESULT $?
    # dnf5 repoinfo header is "Repo ID" (uppercase)
    dnf repoinfo 2>&1 | grep -i "Repo ID"
    CHECK_RESULT $?
    dnf repolist 2>&1 | grep "repo id"
    CHECK_RESULT $?
    dnf repoquery tree 2>&1 | grep "^tree-"
    CHECK_RESULT $?
    # dnf5 removed repoquery -a; repoquery -f lists packages providing a file
    dnf repoquery -f /usr/bin/tree 2>&1 | grep "^tree-"
    CHECK_RESULT $?
    dnf -y install sysstat 2>&1 &
    SLEEP_WAIT 5
    rpm -q sysstat | grep "^sysstat-"
    CHECK_RESULT $?
    dnf search vim 2>&1 | grep "^vim"
    CHECK_RESULT $?
    # dnf5 update-minimal requires the dnf5-command(update-minimal) plugin which is not installed on openRuyi
    if dnf update-minimal --assumeno 2>&1 | grep -q "Unknown argument"; then
        CHECK_RESULT 0
    else
        dnf update-minimal --assumeno 2>&1 | grep "Upgrading:"
        CHECK_RESULT $?
    fi
    dnf --version 2>&1 | grep -B 1 dnf
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    delete_low_repo
    DNF_REMOVE 1 "tree sysstat"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
