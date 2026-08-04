#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   ding_jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2026-08-03
# @License   :   Mulan PSL v2
# @Desc      :   Test cifs-utils package installation integrity
# ############################################
# shellcheck disable=SC2119

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "cifs-utils"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test package_installed: Verify package is installed
    rpm -q cifs-utils > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "cifs-utils package not installed"

    # Test package_integrity: Verify package integrity
    rpm -V --nomtime cifs-utils > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Package integrity check failed"

    # Test package_files: Verify package contains files
    file_count=$(rpm -ql cifs-utils 2>/dev/null | wc -l)
    [ "$file_count" -gt 0 ]
    CHECK_RESULT $? 0 0 "Package contains no files"

    # Test critical_binaries: Verify all required binaries exist
    critical_binaries=(
        "/usr/bin/cifscreds"
        "/usr/bin/getcifsacl"
        "/usr/bin/setcifsacl"
        "/usr/bin/smbinfo"
        "/usr/sbin/mount.cifs"
        "/usr/sbin/mount.smb3"
        "/usr/sbin/cifs.idmap"
    )
    for f in "${critical_binaries[@]}"; do
        [ -e "$f" ]
        CHECK_RESULT $? 0 0 "Critical binary missing: $f"
    done

    # Test config_files: Verify configuration files exist
    config_files=(
        "/etc/cifs-utils/idmap-plugin"
        "/etc/request-key.d/cifs.idmap.conf"
        "/etc/request-key.d/cifs.spnego.conf"
    )
    for f in "${config_files[@]}"; do
        [ -f "$f" ]
        CHECK_RESULT $? 0 0 "Config file missing: $f"
    done

    # Test library_files: Verify library files exist
    [ -f "/usr/lib64/cifs-utils/idmapwb.so" ]
    CHECK_RESULT $? 0 0 "idmapwb.so library missing"
    [ -f "/usr/lib64/security/pam_cifscreds.so" ]
    CHECK_RESULT $? 0 0 "pam_cifscreds.so library missing"

    # Test version: Verify mount.cifs and mount.smb3 version
    mount.cifs -V 2>&1 | grep -E "[0-9]+\.[0-9]+" > /dev/null
    CHECK_RESULT $? 0 0 "mount.cifs version output missing"
    mount.smb3 -V 2>&1 | grep -E "[0-9]+\.[0-9]+" > /dev/null
    CHECK_RESULT $? 0 0 "mount.smb3 version output missing"

    # Test dependencies: Verify package dependencies
    rpm -q keyutils > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "keyutils dependency not satisfied"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
