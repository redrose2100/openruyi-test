#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhujinlong
#@Contact       :   zhujinlong@163.com
#@Date          :   2023-07-26
#@License       :   Mulan PSL v2
#@Desc          :   Common Skill: Manage rpm packages-dnf commands
#####################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    Default_LANG=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dnf config-manager --disable OS
    CHECK_RESULT $? 0 0 "Failed to set the OS repository to be unavailable"
    dnf repolist --all | grep "disabled"
    CHECK_RESULT $? 0 0 "Failed to displays the all repository"
    dnf repolist --enabled | grep -v "OS"
    CHECK_RESULT $? 0 0 "Failed to displays the enabled repository"
    dnf repolist --disabled | grep "OS"
    CHECK_RESULT $? 0 0 "Failed to displays the disabled OS repository"
    dnf config-manager --enable OS
    CHECK_RESULT $? 0 0 "Failed to set the OS repository to be available"
    dnf install tree -y | grep "Installed"
    CHECK_RESULT $? 0 0 "Failed to install the RPM pkg"
    expect <<-EOF
    spawn dnf reinstall tree
    expect "Is this ok"
    send "y\\n"
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Failed to reinstall the RPM pkg"
    expect <<-EOF
    spawn dnf remove tree
    expect "Is this ok"
    send "y\\n"
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Failed to uninstall the RPM pkg"
    dnf install tree -y | grep "Installed"
    CHECK_RESULT $? 0 0 "Failed to install the RPM pkg"
    dnf remove tree --assumeyes | grep "Removed"
    CHECK_RESULT $? 0 0 "Failed to uninstall the RPM pkg"
    dnf install tree --allowerasing --skip-broken -y | grep "Installed"
    CHECK_RESULT $? 0 0 "Failed to install the RPM pkg"
    dnf remove tree -y
    dnf install tree --installroot /tmp -y | grep "Installed"
    CHECK_RESULT $? 0 0 "Failed to set the root directory for installing the RPM pkg"
    dnf remove tree --installroot /tmp -y --exclude=setup | grep "Removed"
    CHECK_RESULT $? 0 0 "Failed to set the root directory for uninstalling the RPM pkg"
    dnf install tree --setopt=reposdir=/etc/yum.repos.d/ -y | grep "Installed"
    CHECK_RESULT $? 0 0 "Failed to specify the specific repo repository to install the RPM pkg"
    dnf remove tree --setopt=reposdir=/etc/yum.repos.d/ -y | grep "Removed"
    CHECK_RESULT $? 0 0 "Failed to specify the specific repo repository to uninstall the RPM pkg"
    dnf install net-tools --repo="everything" -y | grep "Installed"
    CHECK_RESULT $? 0 0 "Failed to specify the specific repo repository to install the RPM pkg"
    dnf autoremove net-tools -y | grep "Removed"
    CHECK_RESULT $? 0 0 "Failed to automatically removes pkgs installed because of dependencies the RPM pkg"
    pkg_name=$(dnf list --updates | grep "x86_64\|arch" | awk '{print $1}' | awk -F"." '{print $1}' | shuf -n1)
    if [ "$pkg_name"x == x ]; then
        echo "There are no upgradable pkgs"
    else
        dnf upgrade "$pkg_name" -y | grep "Upgraded"
        CHECK_RESULT $? 0 0 "Failed to upgrade the installed RPM pkg"
        dnf downgrade "$pkg_name" -y | grep "Downgraded"
        CHECK_RESULT $? 0 0 "Failed to downgrade the installed RPM pkg"
    fi
    dnf list --all | grep -v "arch\|x86_64\|src" | grep "Installed"
    CHECK_RESULT $? 0 0 "Failed to list the all pkgs"
    dnf list --available | grep -v "arch\|x86_64\|src" | grep "Available"
    CHECK_RESULT $? 0 0 "Failed to list the available pkgs"
    dnf list --installed | grep -v "arch\|x86_64\|src" | grep "Installed"
    CHECK_RESULT $? 0 0 "Failed to list the installed pkgs"
    if dnf repolist | grep update; then
        dnf list --updates | grep "Available Upgrades"
        CHECK_RESULT $? 0 0 "Failed to list the updatable pkgs"
    else
        dnf list --updates
        CHECK_RESULT $? 0 0 "Failed to list the updatable pkgs"
    fi
    dnf list --recent
    CHECK_RESULT $? 0 0 "Failed to list the recently changed pkgs"
    dnf info dnf | grep "Description"
    CHECK_RESULT $? 0 0 "Failed to get the pkg details"
    dnf search dnf | grep "dnf-help"
    CHECK_RESULT $? 0 0 "Failed to search the pkg"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=$Default_LANG
    rm -rf /tmp/*
    LOG_INFO "End to restore the test environment."
}

main "$@"
