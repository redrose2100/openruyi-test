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
# @Author    :   2401_86190146
# @Contact   :   202422460152@mail.sdu.edu.cn
# @Date      :   2026-04-23
# @License   :   Mulan PSL v2
# @Desc      :   Test xfsprogs command line tools
# #############################################

# shellcheck source=../common/common_lib.sh
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "xfsprogs"
    TEST_DIR="/tmp/xfsprogs_test"
    mkdir -p "${TEST_DIR}"

    if ! dd if=/dev/zero of="${TEST_DIR}/test.img" bs=1M count=400 2>/dev/null; then
        LOG_ERROR "Failed to create test image file"
        exit 1
    fi

    local mkfs_out
    if ! mkfs_out=$(mkfs.xfs -f "${TEST_DIR}/test.img" 2>&1); then
        LOG_ERROR "mkfs.xfs failed: ${mkfs_out}"
        exit 1
    fi

    local magic
    magic=$(xfs_db -r "${TEST_DIR}/test.img" -c "sb 0" -c "p magicnum" 2>/dev/null | awk '{print $NF}')
    if [ "${magic}" != "0x58465342" ] && [ "${magic}" != "XFSB" ]; then
        LOG_ERROR "XFS filesystem magic number mismatch, got: ${magic}"
        exit 1
    fi

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test 1: xfs_info command exists
    LOG_INFO "Test 1: Check xfs_info command"
    which xfs_info
    CHECK_RESULT $? 0 0 "xfs_info command not found"

    # Test 2: xfs_info on image file
    LOG_INFO "Test 2: xfs_info on image file"
    xfs_info "${TEST_DIR}/test.img" 2>&1 | grep -qi "xfs"
    CHECK_RESULT $? 0 0 "xfs_info failed"

    # Test 3: xfs_db command exists
    LOG_INFO "Test 3: Check xfs_db command"
    which xfs_db
    CHECK_RESULT $? 0 0 "xfs_db command not found"

    # Test 4: xfs_db version information (using -V option, no device needed)
    LOG_INFO "Test 4: xfs_db version information"
    xfs_db -V 2>&1 | grep -qi "version"
    CHECK_RESULT $? 0 0 "xfs_db version failed"

    # Test 4b: xfs_db basic device access (read-only)
    LOG_INFO "Test 4b: xfs_db basic device access"
    local db_output
    if ! db_output=$(xfs_db -r "${TEST_DIR}/test.img" -c "quit" 2>&1); then
        LOG_ERROR "xfs_db quit failed, output: ${db_output}"
        CHECK_RESULT 1 0 0 "xfs_db quit failed"
    else
        CHECK_RESULT 0 0 0 "xfs_db quit failed"
    fi

    # Test 5: xfs_repair command exists
    LOG_INFO "Test 5: Check xfs_repair command"
    which xfs_repair
    CHECK_RESULT $? 0 0 "xfs_repair command not found"

    # Test 6: xfs_repair dry run (clean filesystem expects 0)
    LOG_INFO "Test 6: xfs_repair dry run"
    local repair_output
    if ! repair_output=$(xfs_repair -n "${TEST_DIR}/test.img" 2>&1); then
        LOG_ERROR "xfs_repair dry run failed, output: ${repair_output}"
        CHECK_RESULT 1 0 0 "xfs_repair dry run failed"
    else
        CHECK_RESULT 0 0 0 "xfs_repair dry run failed"
    fi

    # Test 7: xfs_growfs command exists
    LOG_INFO "Test 7: Check xfs_growfs command"
    which xfs_growfs
    CHECK_RESULT $? 0 0 "xfs_growfs command not found"

    # Test 8: xfs_growfs help information
    LOG_INFO "Test 8: xfs_growfs help information"
    xfs_growfs --help 2>&1 | grep -qi "usage"
    CHECK_RESULT $? 0 0 "xfs_growfs help failed"

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    rm -rf "${TEST_DIR}"
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"