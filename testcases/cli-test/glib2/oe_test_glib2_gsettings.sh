#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2026/08/04
# @License   :   Mulan PSL v2
# @Desc      :   test gsettings command
# ############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL glib2
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test help (only one help test)
    gsettings help | grep -i "Usage"
    CHECK_RESULT $? 0 0 "gsettings help check failed"

    # Test --version
    gsettings --version | grep "$(rpm -q glib2 | awk -F '-' '{print $2}')"
    CHECK_RESULT $? 0 0 "gsettings --version check failed"

    # Test list-schemas
    timeout 5 gsettings list-schemas | grep "org.gnome"
    CHECK_RESULT $? 0 0 "gsettings list-schemas check failed"

    # Test list-relocatable-schemas
    timeout 5 gsettings list-relocatable-schemas
    CHECK_RESULT $? 0 0 "gsettings list-relocatable-schemas check failed"

    # Test list-keys
    timeout 5 gsettings list-keys org.gnome.crypto.pgp | grep "ascii-armor"
    CHECK_RESULT $? 0 0 "gsettings list-keys check failed"

    # Test list-recursively
    timeout 5 gsettings list-recursively | grep "org.gnome.crypto.pgp"
    CHECK_RESULT $? 0 0 "gsettings list-recursively check failed"

    # Test get
    timeout 5 gsettings get org.gnome.crypto.pgp ascii-armor | grep -E "true"
    CHECK_RESULT $? 0 0 "gsettings get check failed"

    # Test range
    timeout 5 gsettings range org.gnome.crypto.pgp ascii-armor | grep "type"
    CHECK_RESULT $? 0 0 "gsettings range check failed"

    # Test describe
    timeout 5 gsettings describe org.gnome.crypto.pgp ascii-armor | grep "encrypting"
    CHECK_RESULT $? 0 0 "gsettings describe check failed"

    # Test writable
    timeout 5 gsettings writable org.gnome.crypto.pgp ascii-armor | grep -E "true"
    CHECK_RESULT $? 0 0 "gsettings writable check failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    export LANG=$OLD_LANG
    LOG_INFO "End to restore the test environment."
}

main "$@"