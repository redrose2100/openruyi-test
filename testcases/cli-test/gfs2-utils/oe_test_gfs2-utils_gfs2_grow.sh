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
# @Desc      :   test gfs2_grow command
# ############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to config params of the case."
    TEST_IMG="/tmp/test_gfs2_grow.img"
    TEST_MNT="/tmp/gfs2_grow_mnt"
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gfs2-utils"
    dd if=/dev/zero of="${TEST_IMG}" bs=1M count=100
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
    gfs2_grow -h 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "gfs2_grow -h check failed"
    # Test -V option (version)
    gfs2_grow -V | grep -E "$(rpm -q gfs2-utils | awk -F '-' '{print $3}')"
    CHECK_RESULT $? 0 0 "gfs2_grow -V check failed"
    # Test -T option (dry run, do everything except update file system)
    truncate -s 200M "${TEST_IMG}"
    losetup -c "${LOOP_DEV}"
    gfs2_grow -T "${TEST_MNT}"  | grep -i "Device"
    CHECK_RESULT $? 0 0 "gfs2_grow -T check failed"
    # Test -v option (verbose)
    gfs2_grow -v "${TEST_MNT}"  | grep -i "Trying"
    CHECK_RESULT $? 0 0 "gfs2_grow -v check failed"
    # Test -q option (quiet) - resize again so there's room to grow
    truncate -s 300M "${TEST_IMG}"
    losetup -c "${LOOP_DEV}"
    gfs2_grow -q "${TEST_MNT}" > test_out.txt 2>&1
    test -s test_out.txt
    CHECK_RESULT $? 0 1 "gfs2_grow -q check failed"
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
