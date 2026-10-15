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
# @Desc      :   test glib-gettextize command
# ############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "glib2 glib2-devel"
    rm -rf /tmp/test_gettextize /tmp/test_gettextize_copy /tmp/test_gettextize_force /tmp/test_gettextize_combo
    mkdir -p /tmp/test_gettextize
    cat > /tmp/test_gettextize/configure.ac << 'EOF'
AC_INIT([test], [1.0])
AC_CONFIG_SRCDIR([main.c])
AM_GNU_GETTEXT([external])
EOF
    cp -r /tmp/test_gettextize /tmp/test_gettextize_copy
    cp -r /tmp/test_gettextize /tmp/test_gettextize_force
    cp -r /tmp/test_gettextize /tmp/test_gettextize_combo
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    glib-gettextize --help | grep -i "Usage"
    CHECK_RESULT $? 0 0 "glib-gettextize --help check failed"
    
    glib-gettextize --version | grep "$(rpm -q glib2 | awk -F '-' '{print $2}')"
    CHECK_RESULT $? 0 0 "glib-gettextize --version check failed"
    
    # Test basic usage (creates po/ dir and symlinks Makefile.in.in)
    glib-gettextize /tmp/test_gettextize
    CHECK_RESULT $? 0 0 "glib-gettextize basic check failed"
    test -d /tmp/test_gettextize/po
    CHECK_RESULT $? 0 0 "glib-gettextize po directory check failed"
    test -L /tmp/test_gettextize/po/Makefile.in.in
    CHECK_RESULT $? 0 0 "glib-gettextize symlink check failed"
    
    # Test --copy (creates file instead of symlink)
    glib-gettextize --copy /tmp/test_gettextize_copy
    CHECK_RESULT $? 0 0 "glib-gettextize --copy check failed"
    test -f /tmp/test_gettextize_copy/po/Makefile.in.in
    CHECK_RESULT $? 0 0 "glib-gettextize --copy file check failed"
    test ! -L /tmp/test_gettextize_copy/po/Makefile.in.in
    CHECK_RESULT $? 0 0 "glib-gettextize --copy not symlink check failed"
    
    # Test --force (overwrites existing files)
    glib-gettextize --force /tmp/test_gettextize_force
    CHECK_RESULT $? 0 0 "glib-gettextize --force check failed"
    test -d /tmp/test_gettextize_force/po
    CHECK_RESULT $? 0 0 "glib-gettextize --force po directory check failed"
    
    # Test --copy --force (combines both)
    glib-gettextize --copy --force /tmp/test_gettextize_combo
    CHECK_RESULT $? 0 0 "glib-gettextize --copy --force check failed"
    test -f /tmp/test_gettextize_combo/po/Makefile.in.in
    CHECK_RESULT $? 0 0 "glib-gettextize --copy --force file check failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf /tmp/test_gettextize /tmp/test_gettextize_copy /tmp/test_gettextize_force /tmp/test_gettextize_combo
    LOG_INFO "End to restore the test environment."
}

main "$@"
