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
# @Desc      :   test fsck.gfs2 command
# ############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to config params of the case."
    TEST_IMG="/tmp/test_gfs2_fsck.img"
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gfs2-utils"
    dd if=/dev/zero of="${TEST_IMG}" bs=1M count=200
    LOOP_DEV=$(losetup -f --show "${TEST_IMG}")
    mkfs.gfs2 -O -p lock_nolock "${LOOP_DEV}"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test -h option
    fsck.gfs2 -h | grep -i "usage"
    CHECK_RESULT $? 0 0 "fsck.gfs2 -h check failed"
    # Test -V option (version)
    fsck.gfs2 -V 2>&1 | grep -iE "$(rpm -q gfs2-utils | awk -F '-' '{print $3}')|Copyright"
    CHECK_RESULT $? 0 0 "fsck.gfs2 -V check failed"
    # Test -v option (verbose)
    fsck.gfs2 -v "${LOOP_DEV}" | grep "Checking"
    CHECK_RESULT $? 0 0 "fsck.gfs2 -v check failed"
    # Test -n option (dry run)
    fsck.gfs2 -n "${LOOP_DEV}" | grep -i "fsck.gfs2 complete"
    CHECK_RESULT $? 0 0 "fsck.gfs2 -n check failed"
    # Test -y option (yes to all prompts)
    fsck.gfs2 -y "${LOOP_DEV}" | grep -i "fsck.gfs2 complete"
    CHECK_RESULT $? 0 0 "fsck.gfs2 -y check failed"
    # Test -a option (auto repair)
    fsck.gfs2 -a "${LOOP_DEV}" 2>&1 | grep -i "clean"
    CHECK_RESULT $? 0 0 "fsck.gfs2 -a check failed"
    # Test -p option (paranoid)
    fsck.gfs2 -p "${LOOP_DEV}" 2>&1 | grep -i "loop"
    CHECK_RESULT $? 0 0 "fsck.gfs2 -p check failed"
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
