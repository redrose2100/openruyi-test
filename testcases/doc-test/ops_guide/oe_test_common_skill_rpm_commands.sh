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
#@Date          :   2023-07-25
#@License       :   Mulan PSL v2
#@Desc          :   Common Skill: Manage rpm packages-rpm commands
#####################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    Default_LANG=$LANG
    export LANG=en_US.UTF-8
    rpm -qa |grep gpg-pubkey && rpm -e gpg-pubkey
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    rpm --import "$(rpm -qa |grep gpg-keys |xargs rpm -ql |grep -i euler)"
    CHECK_RESULT $? 0 0 "Failed to import gpgkey"
    yumdownloader nano | grep "nano"
    CHECK_RESULT $? 0 0 "Failed to download nano pkg"
    rpm --checksig "$(ls nano*)" | grep -iE "digests signatures OK|digests OK"
    CHECK_RESULT $? 0 0 "Failed to check RPM signature"
    rpm -e gpg-pubkey
    CHECK_RESULT $? 0 0 "Failed to delete gpgkey"
    rpm -ivh nano* | grep "installing..."
    CHECK_RESULT $? 0 0 "Failed to install rpm pkg"
    rpm -ev nano | grep "nano"
    CHECK_RESULT $? 0 0 "Failed to uninstall rpm pkg"
    rpm -q dnf | grep "dnf"
    CHECK_RESULT $? 0 0 "Failed to query the installed RPM pkg"
    rpm -q tree | grep "package tree is not installed"
    CHECK_RESULT $? 0 0 "Failed to query the uninstalled RPM pkg"
    rpm -qa | grep "kernel"
    CHECK_RESULT $? 0 0 "Failed to query kernel in all installed RPM pkgs"
    rpm -qi python3 | grep "Summary"
    CHECK_RESULT $? 0 0 "Failed to query details about the installed RPM pkg"
    rpm -qlp nano* | grep "/usr/bin/nano"
    CHECK_RESULT $? 0 0 "Failed to query the list of uninstalled RPM pkgs"
    rpm -qRp nano* | grep "rtld(GNU_HASH)"
    CHECK_RESULT $? 0 0 "Failed to query uninstalled RPM pkg dependencies"
    rpm -Va
    CHECK_RESULT $? 1 0 "No information difference"
    rpm -qf /usr/bin/dnf | grep "dnf"
    CHECK_RESULT $? 0 0 "Failed to query the RPM pkg for a specific file"
    rpm -ql dnf | grep "/usr/bin/dnf"
    CHECK_RESULT $? 0 0 "Failed to query the files in the installed RPM pkg"
    rpm -qa --last | grep "dnf"
    CHECK_RESULT $? 0 0 "Failed to query the recently installed RPM pkg"
    rpm -qdf /usr/bin/grep | grep "/usr/share/doc/grep/README"
    CHECK_RESULT $? 0 0 "Failed to query the doc of the installed RPM pkg"
    pkg_name=$(dnf list --updates | grep "x86_64\|arch" | awk '{print $1}' | awk -F"." '{print $1}' | shuf -n1)
    if [ "$pkg_name"x == x ]; then
        echo "There are no upgradable pkgs"
    else
        pkg_version=$(rpm -qa "$pkg_name")
        yumdownloader "$pkg_name"
        rpm -Uvh "$pkg_name*" --nodeps | grep "Updating"
        CHECK_RESULT $? 0 0 "Failed to upgrade the installed RPM pkg"
        yumdownloader "$pkg_version"
        rpm -Uvh --oldpackage "${pkg_version}".rpm | grep "Updating"
        CHECK_RESULT $? 0 0 "Failed to downgrade the installed RPM pkg"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=$Default_LANG
    rm -rf ./*.rpm
    LOG_INFO "End to restore the test environment."
}

main "$@"
