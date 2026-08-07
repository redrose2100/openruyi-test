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
# @Date      :   2026/08/07
# @License   :   Mulan PSL v2
# @Desc      :   test gfs2_jadd command
# ############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to config params of the case."
    TEST_IMG="/tmp/test_gfs2_jadd.img"
    TEST_MNT="/tmp/gfs2_jadd_mnt"
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gfs2-utils"
    dd if=/dev/zero of="${TEST_IMG}" bs=1M count=800
    LOOP_DEV=$(losetup -f --show "${TEST_IMG}")
    mkfs.gfs2 -O -p lock_nolock "${LOOP_DEV}"
    mkdir -p "${TEST_MNT}"
    if ! mount -t gfs2 "${LOOP_DEV}" "${TEST_MNT}" 2>/dev/null; then
        LOG_INFO "GFS2 filesystem not supported, skip the test."
        exit 255
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test -h option
    gfs2_jadd -h 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "gfs2_jadd -h check failed"
    # Test -V option (version)
    gfs2_jadd -V 2>&1 | grep -E "$(rpm -q gfs2-utils | awk -F '-' '{print $3}')"
    CHECK_RESULT $? 0 0 "gfs2_jadd -V check failed"
    # Test -J option (journal size)
    gfs2_jadd -J 50 "${TEST_MNT}" | grep -i "journal"
    CHECK_RESULT $? 0 0 "gfs2_jadd -J check failed"
    # Test -j option (journal count)
    gfs2_jadd -j 1 "${TEST_MNT}" | grep -i "journal"
    CHECK_RESULT $? 0 0 "gfs2_jadd -j check failed"
    # Test -D option (debug)
    gfs2_jadd -D "${TEST_MNT}" | grep -i "Command"
    CHECK_RESULT $? 0 0 "gfs2_jadd -D check failed"
    # Test -c option (quota change file size)
    gfs2_jadd -c 2 "${TEST_MNT}" | grep -i "Filesystem:"
    CHECK_RESULT $? 0 0 "gfs2_jadd -c check failed"
    # Test -q option (quiet)
    gfs2_jadd -q "${TEST_MNT}" > test_out.txt 2>&1
    test -s test_out.txt
    CHECK_RESULT $? 0 1 "gfs2_jadd -q check failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    umount "${TEST_MNT}"
    losetup -d "${LOOP_DEV}"
    rm -rf "${TEST_MNT}" "${TEST_IMG}" test_out.txt
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
