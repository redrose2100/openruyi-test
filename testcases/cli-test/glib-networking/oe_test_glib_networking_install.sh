#!/usr/bin/bash

# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   ding_jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2026-07-29
# @License   :   Mulan PSL v2
# @Desc      :   Test glib-networking package installation integrity
# ############################################
# shellcheck disable=SC2119

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "glib-networking"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test 1: Verify package is installed
    rpm -q glib-networking > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "glib-networking package not installed"

    # Test 2: Verify package integrity check (ignore mtime to avoid false positives)
    rpm -V --nomtime glib-networking > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Package integrity check failed (rpm -V)"

    # Test 3: Verify package contains files
    file_count=$(rpm -ql glib-networking 2>/dev/null | wc -l)
    [ "$file_count" -gt 0 ]
    CHECK_RESULT $? 0 0 "Package contains no files"

    # Test 4: Verify documentation directory exists
    [ -d "/usr/share/doc/glib-networking" ]
    CHECK_RESULT $? 0 0 "Documentation directory missing"

    # Test 5: Verify critical files exist
    critical_files=(
        "/usr/lib64/gio/modules/libgiognutls.so"
        "/usr/lib64/gio/modules/libgiognomeproxy.so"
        "/usr/lib64/gio/modules/libgiolibproxy.so"
        "/usr/libexec/glib-pacrunner"
        "/usr/lib/systemd/user/glib-pacrunner.service"
        "/usr/share/dbus-1/services/org.gtk.GLib.PACRunner.service"
    )
    for f in "${critical_files[@]}"; do
        [ -e "$f" ]
        CHECK_RESULT $? 0 0 "Critical file missing: $f"
    done

    # Test 6: Verify dependencies are installed
    for dep in gsettings-desktop-schemas libproxy; do
        rpm -q "$dep" > /dev/null 2>&1
        CHECK_RESULT $? 0 0 "Dependency $dep not installed"
    done

    # Test 7: Verify GIO module cache exists
    [ -f "/usr/lib64/gio/modules/giomodule.cache" ]
    CHECK_RESULT $? 0 0 "GIO module cache missing"

    # Test 8: Verify GIO modules have no unresolved dynamic dependencies
    for mod in libgiognutls.so libgiognomeproxy.so libgiolibproxy.so; do
        modpath="/usr/lib64/gio/modules/$mod"
        ldd "$modpath" 2>/dev/null | grep "not found" > /dev/null
        CHECK_RESULT $? 1 0 "GIO module $mod has unresolved library dependencies"
    done

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
