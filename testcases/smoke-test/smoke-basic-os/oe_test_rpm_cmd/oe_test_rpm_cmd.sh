#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2022/06/25
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of rpm
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "python3-pip dnf-plugins-core"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    yumdownloader tcllib
    rpm -qip tcllib*.rpm | grep Name
    CHECK_RESULT $? 0 0 "Failed to execute rpm -qip"
    rpm -ivh tcllib*.rpm
    CHECK_RESULT $? 0 0 "Failed to execute rpm -ivh"
    rpm -qa | grep -v help | grep tcllib
    CHECK_RESULT $? 0 0 "Failed to execute rpm -qa"
    rpm -qi tcllib
    CHECK_RESULT $? 0 0 "Failed to execute rpm -qi"
    rpm -ql tcllib
    CHECK_RESULT $? 0 0 "Failed to execute rpm -ql"
    rpm -e "$(rpm -qa tcllib)"
    CHECK_RESULT $? 0 0 "Failed to execute rpm -e"
    rpm -qa | grep -v help | grep tcllib
    CHECK_RESULT $? 0 1 "Succeed to display tcllib"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tcllib*.rpm
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
