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
# @Desc      :   test glocktop command
# ############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to config params of the case."
    TEST_IMG="/tmp/test_gfs2_glocktop.img"
    TEST_MNT="/tmp/gfs2_glocktop_mnt"
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
    glocktop -h | grep -i "usage"
    CHECK_RESULT $? 0 0 "glocktop -h check failed"
    # Test -t option (trace directory glocks)
    timeout 5 glocktop -t  | grep -i "glock"
    CHECK_RESULT $? 0 0 "glocktop -t check failed"
    # Test -d option (delay)
    timeout --foreground 5 glocktop -d 3  | grep -ic "loop" | grep -x 2
    CHECK_RESULT $? 0 0 "glocktop -d check failed"
    # Test -n option (iterations)
    timeout --foreground 5 glocktop -n 1  | grep -ic "loop" | grep -x 1
    CHECK_RESULT $? 0 0 "glocktop -n check failed"
    # Test -H option (don't show Held glocks)
    timeout --foreground 3 glocktop -H | grep -c "G:.*s"  | grep -x 1
    CHECK_RESULT $? 0 0 "glocktop -H check failed"
    # Test -r option (show reservations)
    timeout --foreground 3 glocktop -r  | grep -i "rgrp"
    CHECK_RESULT $? 0 0 "glocktop -r check failed"
    # Test -s option (show glock summary)
    timeout --foreground 3 glocktop -d 1 -s2 | grep -ic glock  | grep -x 2
    CHECK_RESULT $? 0 0 "glocktop -s check failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    umount "${TEST_MNT}"
    losetup -d "${LOOP_DEV}"
    rm -rf "${TEST_IMG}" "${TEST_MNT}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"