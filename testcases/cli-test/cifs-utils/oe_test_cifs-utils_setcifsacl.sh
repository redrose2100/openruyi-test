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
# @Desc      :   Test setcifsacl command - modify CIFS/NTFS ACL on Samba share
# ############################################
# shellcheck disable=SC2119

source "$OET_PATH/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/common/samba_server.sh"

SMB_CONF="/etc/samba/setcifsacl_test.conf"
SMB_SHARE="/tmp/samba_setcifsacl_share"
CIFS_MOUNT="/mnt/setcifsacltest"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "samba cifs-utils"
    samba_start "$SMB_CONF" "$SMB_SHARE" "$CIFS_MOUNT" "map acl inherit = yes"
    [ $? -ne 0 ] && return 1
    touch "$CIFS_MOUNT/test_file"
    mkdir -p "$CIFS_MOUNT/test_dir"
    touch "$CIFS_MOUNT/test_dir/nested_file"
    test_file="$CIFS_MOUNT/test_file"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test -h: Show help
    setcifsacl -h 2>&1 | grep -i "Usage\|Alter" > /dev/null
    CHECK_RESULT $? 0 0 "setcifsacl -h help missing"

    # Test -v: Show version
    setcifsacl -v 2>&1 | grep -i "version\|cifsacl" > /dev/null
    CHECK_RESULT $? 0 0 "setcifsacl -v version failed"

    # Test no_file: Show error when no file parameter provided
    setcifsacl 2>&1 | grep -i "Usage\|filename" > /dev/null
    CHECK_RESULT $? 0 0 "setcifsacl without file shows error"

    # Test invalid_option: Invalid option produces error
    setcifsacl --invalid 2>&1 | grep -i "invalid\|unknown" > /dev/null
    CHECK_RESULT $? 0 0 "setcifsacl invalid option should fail"

    # Test -a: Add ACE with ALLOWED type
    setcifsacl -a "ACL:S-1-5-18:ALLOWED/0x0/FULL" "$test_file" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "setcifsacl -a ACE format valid on Samba"

    # Test -A: Add ACE with ALLOWED type (alternative)
    setcifsacl -A "ACL:S-1-5-18:ALLOWED/0x0/FULL" "$test_file" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "setcifsacl -A ACE format valid on Samba"

    # Test -M: Modify ACE with specific mask
    setcifsacl -M "ACL:S-1-5-18:ALLOWED/0x0/0x1e01ff" "$test_file" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "setcifsacl -M ACE format valid on Samba"

    # Test -S: Set ACE with delete flag
    setcifsacl -S "ACL:S-1-5-18:ALLOWED/0x0/D" "$test_file" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "setcifsacl -S ACE format valid on Samba"

    # Test multi_file: Accept multiple file arguments
    setcifsacl -a "ACL:S-1-5-18:ALLOWED/0x0/FULL" "$test_file" "$CIFS_MOUNT/test_dir/nested_file" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "setcifsacl multi-file arguments accepted"

    # Test nonexistent_file: Non-existent file should fail
    ! setcifsacl -a "ACL:S-1-5-18:ALLOWED/0x0/FULL" "/nonexistent/file" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "setcifsacl non-existent file should fail"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    samba_stop "$SMB_CONF" "$CIFS_MOUNT"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
