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
    if [ "${NODE1_OS_VERSION}" == "debian" ];then
        DNF_INSTALL "python3-pip dnf-plugins-core tcl"
    else
        DNF_INSTALL "python3-pip dnf-plugins-core"
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    if [ "${NODE1_OS_VERSION}" == "debian" ];then
        apt download tcllib
        dpkg-deb --info tcllib*.deb | grep Package
        CHECK_RESULT $? 0 0 "Failed to execute dpkg-deb --info"
        dpkg -i tcllib*.deb
        CHECK_RESULT $? 0 0 "Failed to execute dpkg -i"
        dpkg -s tcllib | grep "install ok installed"
        CHECK_RESULT $? 0 0 "Failed to execute dpkg -s"
        apt show tcllib
        CHECK_RESULT $? 0 0 "Failed to execute apt show"
        dpkg -L tcllib
        CHECK_RESULT $? 0 0 "Failed to execute dpkg -L"
        apt remove -y tcllib && apt purge -y tcllib
        CHECK_RESULT $? 0 0 "Failed to execute apt remove && apt purge"
        dpkg -s tcllib 2>&1 | grep "not installed"
        CHECK_RESULT $? 0 0 "Failed to execute dpkg -s"
    else
        yumdownloader tcllib
        rpm -qip tcllib*.rpm | grep Name
        CHECK_RESULT $? 0 0 "Failed to execute rpm -qip"
        rpm -ivh tcllib*.rpm
        CHECK_RESULT $? 0 0 "Failed to execute rpm -ivh"
        rpm -qa | grep -v help | grep tcllib
        CHECK_RESULT $? 0 0 "Failed to execute rpm -qa"
        rpm -qi tcllib
        CHECK_RESULT $?dpkg -l 0 0 "Failed to execute rpm -qi"
        rpm -ql tcllib
        CHECK_RESULT $? 0 0 "Failed to execute rpm -ql"
        rpm -e "$(rpm -qa tcllib)"
        CHECK_RESULT $? 0 0 "Failed to execute rpm -e"
        rpm -qa | grep -v help | grep tcllib
        CHECK_RESULT $? 0 1 "Succeed to display tcllib"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    if [ "${NODE1_OS_VERSION}" == "debian" ];then
        rm -rf tcllib*.deb
    else
        rm -rf tcllib*.rpm
    fi
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
