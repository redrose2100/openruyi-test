#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   xiaochn
#@Contact       :   xiaochuannan@inspur.com
#@Date          :   2024-11-22
#@License       :   Mulan PSL v2
#@Desc          :   openEuler-lsb test to upgrade from 5.0-1 to lasted version
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DISTRIB_ID=$(grep '^ID=' /etc/os-release | awk -F'"' '{print $2}')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # skip test if no 5.0-1 version
    PKG_NAME=$(dnf repoquery --nvr "$DISTRIB_ID-lsb-5.0-1.*")
    if [ -z "$PKG_NAME" ]; then
        LOG_WARN "Skip the upgrade test of $DISTRIB_ID-lsb package because there's no 5.0-1 version in repository."
        exit 255
    fi

    # skip test if no other version beside 5.0-1
    PKG_NAME_LATEST=$(dnf repoquery --nvr "$DISTRIB_ID-lsb" | grep -v 5.0-1. | tail -n 1)
    if [ -z "$PKG_NAME_LATEST" ]; then
        LOG_WARN "Skip the upgrade test of $DISTRIB_ID-lsb package because there's no other version beside 5.0-1 in repository."
        exit 255
    fi

    DNF_INSTALL "$PKG_NAME"
    rpm -qa | grep "$PKG_NAME"
    CHECK_RESULT $? 0 0 "DNF_INSTALL $PKG_NAME failed!"
    DNF_INSTALL "$PKG_NAME_LATEST"
    rpm -qa | grep "$PKG_NAME_LATEST"
    CHECK_RESULT $? 0 0 "DNF_INSTALL $PKG_NAME_LATEST failed!"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
