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
# @Author    :   sjxjx
# @Contact   :   3541335833@qq.com
# @Date      :   2026-04-23
# @License   :   Mulan PSL v2
# @Desc      :   Test xfsprogs quota and metadata tools
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "xfsprogs"
    TEST_DIR="/tmp/xfsprogs_test2"
    mkdir -p "${TEST_DIR}"
    dd if=/dev/zero of="${TEST_DIR}/test.img" bs=1M count=100 2>/dev/null
    mkfs.xfs -f "${TEST_DIR}/test.img" >/dev/null 2>&1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test 1: xfs_quota command exists
    LOG_INFO "Test 1: Check xfs_quota command"
    which xfs_quota
    CHECK_RESULT $? 0 0 "xfs_quota command not found"

    # Test 2: xfs_quota help information
    LOG_INFO "Test 2: xfs_quota help information"
    xfs_quota -h 2>&1 | grep -q "Usage"
    CHECK_RESULT $? 0 0 "xfs_quota help failed"

    # Test 3: xfs_metadump command exists
    LOG_INFO "Test 3: Check xfs_metadump command"
    which xfs_metadump
    CHECK_RESULT $? 0 0 "xfs_metadump command not found"

    # Test 4: xfs_metadump help information
    LOG_INFO "Test 4: xfs_metadump help information"
    xfs_metadump -h 2>&1 | grep -q "Usage"
    CHECK_RESULT $? 0 0 "xfs_metadump help failed"

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    rm -rf "${TEST_DIR}"
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
