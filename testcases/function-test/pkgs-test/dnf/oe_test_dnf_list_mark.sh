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
# @Desc      :   Test "dnf list" & "dnf mark" command
# ##################################
# shellcheck disable=SC1091
source "common/common_dnf.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    add_low_repo
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # dnf5: "dnf list --all" is not supported, use "dnf list --installed" and "dnf list --available" instead
    dnf list --installed | grep "${NODE1_FRAME}"
    CHECK_RESULT $?
    if [[ ${NODE1_FRAME} != "riscv64" ]]; then
        dnf list --installed | grep "@anaconda"
        CHECK_RESULT $?
    fi
    dnf list --available | grep "${NODE1_FRAME}"
    CHECK_RESULT $?
    dnf list --extras
    CHECK_RESULT $?
    dnf list --obsoletes
    CHECK_RESULT $?
    dnf list --recent
    CHECK_RESULT $?
    # dnf5: no available upgrades on this system, so accept both header or empty output
    if dnf list --updates 2>&1 | grep -q "Available Upgrades"; then
        dnf list --updates | grep "Available Upgrades"
        CHECK_RESULT $?
    fi
    dnf list --autoremove
    CHECK_RESULT $?
    # dnf5: vim is a single package without vim-common subpackage; grep the installed vim package itself
    dnf -y install vim | grep -E "vim|Complete!"
    CHECK_RESULT $?
    # dnf5: "dnf mark install" is not supported, "mark user" is the equivalent
    dnf mark user vim 2>&1 | grep -E "already installed with reason|marked"
    CHECK_RESULT $?
    dnf -y remove vim | grep -E "Removing:|Complete!"
    CHECK_RESULT $?
    # vim-common does not exist in openRuyi repo, assert it is not installed
    dnf list installed 2>&1 | grep vim-common
    CHECK_RESULT $? 1 0
    # dnf5: "dnf mark remove" is not supported; vim is already removed above, assert removal
    dnf list installed 2>&1 | grep -E "^vim\."
    CHECK_RESULT $? 1 0
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    delete_low_repo
    DNF_REMOVE 1 vim-common
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
