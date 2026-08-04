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
# @Desc      :   Test getcifsacl command - display CIFS/NTFS ACL on Samba share
# ############################################
# shellcheck disable=SC2119

source "$OET_PATH/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/common/samba_server.sh"

SMB_CONF="/etc/samba/getcifsacl_test.conf"
SMB_SHARE="/tmp/samba_getcifsacl_share"
CIFS_MOUNT="/mnt/getcifsacltest"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    
    DNF_INSTALL "samba cifs-utils"
    samba_start "$SMB_CONF" "$SMB_SHARE" "$CIFS_MOUNT"
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
    getcifsacl -h 2>&1 | grep "Usage:" > /dev/null
    CHECK_RESULT $? 0 0 "getcifsacl -h help missing"

    # Test -v: Show version
    getcifsacl -v 2>&1 | grep -i "version\|cifsacl" > /dev/null
    CHECK_RESULT $? 0 0 "getcifsacl -v version failed"

    # Test no_file: Show error when no file argument provided
    getcifsacl 2>&1 | grep -i "specify\|filename\|Usage" > /dev/null
    CHECK_RESULT $? 0 0 "getcifsacl without file shows error"

    # Test basic_usage: Read CIFS file ACL, output contains DACL
    output=$(getcifsacl "$test_file" 2>&1)
    CHECK_RESULT $? 0 0 "getcifsacl basic usage failed"
    echo "$output" | grep -q "DACL:"
    CHECK_RESULT $? 0 0 "getcifsacl basic output missing DACL"

    # Test -r: Show raw values with hex mask
    output=$(getcifsacl -r "$test_file" 2>&1)
    CHECK_RESULT $? 0 0 "getcifsacl -r raw option failed"
    echo "$output" | grep -q "0x[0-9a-fA-F]"
    CHECK_RESULT $? 0 0 "getcifsacl -r output missing raw values"

    # Test -R: Recursive option for directories and subdirectories
    output=$(getcifsacl -R "$CIFS_MOUNT" 2>&1)
    CHECK_RESULT $? 0 0 "getcifsacl -R recursive option failed"
    echo "$output" | grep -q "test_dir"
    CHECK_RESULT $? 0 0 "getcifsacl -R did not recurse into subdirectory"

    # Test multi_file: Multiple file arguments
    output=$(getcifsacl "$test_file" "$CIFS_MOUNT/test_dir/nested_file" 2>&1)
    CHECK_RESULT $? 0 0 "getcifsacl multi-file usage failed"
    echo "$output" | grep -q "nested_file"
    CHECK_RESULT $? 0 0 "getcifsacl multi-file output missing nested_file"

    # Test invalid_option: Invalid option produces error
    getcifsacl --invalid 2>&1 | grep -i "invalid\|unknown" > /dev/null
    CHECK_RESULT $? 0 0 "getcifsacl invalid option should fail"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    samba_stop "$SMB_CONF" "$CIFS_MOUNT"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
