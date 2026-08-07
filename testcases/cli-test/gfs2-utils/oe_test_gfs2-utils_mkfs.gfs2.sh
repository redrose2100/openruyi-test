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
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/08/07
# @License   :   Mulan PSL v2
# @Desc      :   test mkfs.gfs2 command
# ############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to config params of the case."
    TEST_IMG="/tmp/test_gfs2_mkfs.img"
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gfs2-utils"
    dd if=/dev/zero of="${TEST_IMG}" bs=1M count=500
    LOOP_DEV=$(losetup -f --show "${TEST_IMG}")
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test -h option (help)
    mkfs.gfs2 -h 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "mkfs.gfs2 -h check failed"
    # Test -V option (version)
    mkfs.gfs2 -V 2>&1 | grep -iE "$(rpm -q gfs2-utils | awk -F '-' '{print $3}')|Copyright"
    CHECK_RESULT $? 0 0 "mkfs.gfs2 -V check failed"
    # Test -O option (no confirmation)
    mkfs.gfs2 -O -p lock_nolock "${LOOP_DEV}" | grep -i "Discarding"
    CHECK_RESULT $? 0 0 "mkfs.gfs2 -O check failed"
    # Test -K option (no discard)
    mkfs.gfs2 -O -K -p lock_nolock "${LOOP_DEV}" | grep -i "Discarding"
    CHECK_RESULT $? 0 1 "mkfs.gfs2 -K check failed"
    # Test -D option (debug)
    mkfs.gfs2 -O -D -p lock_nolock "${LOOP_DEV}" | grep "^Done"
    CHECK_RESULT $? 0 0 "mkfs.gfs2 -D check failed"
    # Test -b option (block size)
    mkfs.gfs2 -O -b 4096 -p lock_nolock "${LOOP_DEV}" | grep -i "Block size"
    CHECK_RESULT $? 0 0 "mkfs.gfs2 -b check failed"
    # Test -c option (quota change file size)
    mkfs.gfs2 -O -c 2 -p lock_nolock "${LOOP_DEV}" | grep -i "quota file"
    CHECK_RESULT $? 0 0 "mkfs.gfs2 -c check failed"
    # Test -J option (journal size)
    mkfs.gfs2 -O -J 32 -p lock_nolock "${LOOP_DEV}" | grep -i "Journal size:.*32MB"
    CHECK_RESULT $? 0 0 "mkfs.gfs2 -J check failed"
    # Test -j option (number of journals)
    mkfs.gfs2 -O -j 2 -p lock_nolock "${LOOP_DEV}" | grep -i "Journals:.*2"
    CHECK_RESULT $? 0 0 "mkfs.gfs2 -j check failed"
    # Test -q option (quiet)
    mkfs.gfs2 -O -q -p lock_nolock "${LOOP_DEV}"
    CHECK_RESULT $? 0 0 "mkfs.gfs2 -q check failed"
    # Test -r option (resource group size)
    mkfs.gfs2 -O -r 64 -p lock_nolock "${LOOP_DEV}" | grep -i "resource groups"
    CHECK_RESULT $? 0 0 "mkfs.gfs2 -r check failed"
    # Test -t option (lock table name)
    mkfs.gfs2 -O -t lock_dlm:test -p lock_nolock "${LOOP_DEV}" | grep "Lock table:.*lock_dlm:test"
    CHECK_RESULT $? 0 0 "mkfs.gfs2 -t check failed"
    if mkfs.gfs2 -h | grep "\-U";then
        # Test -U option (UUID)
        mkfs.gfs2 -O -U 12345678-1234-1234-1234-123456789abc -p lock_nolock "${LOOP_DEV}" | grep "UUID.*12345678-1234"
        CHECK_RESULT $? 0 0 "mkfs.gfs2 -U check failed"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    losetup -d "${LOOP_DEV}"
    rm -f "${TEST_IMG}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"