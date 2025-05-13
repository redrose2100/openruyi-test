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
#@Date          :   2020/5/13
#@License       :   Mulan PSL v2
#@Desc          :   Test enabled=0 & enabled=1, Test "--enablerepo=<repoid>" option
###################################
# shellcheck disable=SC1091
source "common/common_dnf.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    grep -B5 "enabled=1" /etc/yum.repos.d/*.repo | grep "name=OS"
    CHECK_RESULT $?
    dnf repolist | grep OS
    CHECK_RESULT $?
    grep -B5 "enabled=1" /etc/yum.repos.d/*.repo | grep "name=everything"
    CHECK_RESULT $?
    dnf repolist | grep everything
    CHECK_RESULT $?
    dnf config-manager --set-disable "*"
    dnf repolist | grep "OS\|everything"
    CHECK_RESULT $? 1 0 "disable repo failed"
    dnf install -y sysstat 2>&1 | grep "There are no enabled repositories"
    CHECK_RESULT $?
    dnf remove -y sysstat
    dnf --enablerepo=EPOL repolist | grep EPOL
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dnf config-manager --set-enable "OS" "everything"
    clear_env
    LOG_INFO "End of restore the test environment."
}

main "$@"
