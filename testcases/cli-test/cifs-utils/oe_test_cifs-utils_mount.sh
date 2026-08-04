#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2026-08-03
# @License   :   Mulan PSL v2
# @Desc      :   Test mount.cifs command with local Samba server
# ############################################
# shellcheck disable=SC2119

source "$OET_PATH/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/common/samba_server.sh"

SMB_CONF="/etc/samba/mountcifs_test.conf"
SMB_SHARE="/tmp/samba_cifs_share"
MOUNT_POINT="/mnt/cifstest"
TMP_MOUNT="/tmp/cifs_invalid_mount"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "samba cifs-utils"
    samba_start "$SMB_CONF" "$SMB_SHARE" "$MOUNT_POINT"
    [ $? -ne 0 ] && return 1
    echo "cifs test content" > "$SMB_SHARE/test.txt"
    mkdir -p "$SMB_SHARE/subdir"
    echo "nested cifs content" > "$SMB_SHARE/subdir/nested.txt"
    umount -lf "$MOUNT_POINT" 2>/dev/null
    mount.cifs "//127.0.0.1/testshare" "$MOUNT_POINT" -o "username=root,password=${NODE1_PASSWORD},vers=2.0" > /dev/null 2>&1
    mkdir -p "$TMP_MOUNT"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test -V: Show version
    mount.cifs -V > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "mount.cifs -V version failed"

    # Test no_args: Show usage when no arguments provided
    mount.cifs 2>&1 | grep "Usage:" > /dev/null
    CHECK_RESULT $? 0 0 "mount.cifs help not displayed"

    # Test missing_args: Return non-zero when arguments missing
    mount.cifs "//127.0.0.1/testshare" > /dev/null 2>&1
    CHECK_RESULT $? 1 0 "mount.cifs missing args should fail"

    # Test invalid_option: Produce error with invalid option
    mount.cifs "//127.0.0.1/testshare" "$TMP_MOUNT" -o "invalidopt=val,username=root,password=${NODE1_PASSWORD},vers=2.0" 2>&1 | grep -i "invalid\|Unrecognized\|bad option" > /dev/null
    CHECK_RESULT $? 0 0 "mount.cifs invalid option should fail"

    # Test mount_exists: Verify current mount exists in mount table
    mount | grep -q "$MOUNT_POINT"
    CHECK_RESULT $? 0 0 "mount.cifs mount not found in mount table"

    # Test file_visible: Verify file is readable
    [ -f "$MOUNT_POINT/test.txt" ]
    CHECK_RESULT $? 0 0 "mount.cifs: test.txt not visible"

    # Test file_content: Read file content
    grep -q "cifs test content" "$MOUNT_POINT/test.txt"
    CHECK_RESULT $? 0 0 "mount.cifs: file content mismatch"

    # Test write_file: Write new file
    echo "new write test" > "$MOUNT_POINT/write_test.txt"
    [ -f "$MOUNT_POINT/write_test.txt" ]
    CHECK_RESULT $? 0 0 "mount.cifs: write failed"

    # Test subdir_visible: Verify subdirectory
    [ -d "$MOUNT_POINT/subdir" ]
    CHECK_RESULT $? 0 0 "mount.cifs: subdir not visible"
    grep -q "nested cifs content" "$MOUNT_POINT/subdir/nested.txt"
    CHECK_RESULT $? 0 0 "mount.cifs: nested file content mismatch"

    # Test umount: Unmount verification
    umount "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "umount failed after mount.cifs"

    # Test already_unmounted: Verify already unmounted
    mount | grep -q "$MOUNT_POINT"
    CHECK_RESULT $? 1 0 "mount.cifs: still mounted after umount"

    # Test ro_mount: Read-only mount
    mount.cifs "//127.0.0.1/testshare" "$MOUNT_POINT" -o "username=root,password=${NODE1_PASSWORD},vers=2.0,ro" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "mount.cifs ro mount failed"

    # Test ro_option: Verify read-only option applied
    mount | grep "$MOUNT_POINT" | grep -q "ro,"
    CHECK_RESULT $? 0 0 "mount.cifs ro option not applied"

    # Test ro_write_fail: Write should fail on read-only mount
    echo "should fail" > "$MOUNT_POINT/should_not_write.txt" 2>/dev/null
    CHECK_RESULT $? 1 0 "mount.cifs: write on ro mount should fail"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    umount "$MOUNT_POINT" > /dev/null 2>&1
    rmdir "$TMP_MOUNT" 2>/dev/null
    samba_stop "$SMB_CONF" "$MOUNT_POINT"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
