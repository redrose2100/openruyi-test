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
# @Desc      :   test tunegfs2 command
# ############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to config params of the case."
    TEST_IMG="/tmp/test_gfs2_tunegfs2.img"
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
    # Test -h option (help)
    tunegfs2 -h  | grep -i "usage"
    CHECK_RESULT $? 0 0 "tunegfs2 -h check failed"
    # Test -V option (version)
    tunegfs2 -V 2>&1 | grep -i "tunegfs2"
    CHECK_RESULT $? 0 0 "tunegfs2 -V check failed"
    # Test -L option (set label)
    tunegfs2 -L testlabel "${LOOP_DEV}"
    CHECK_RESULT $? 0 0 "tunegfs2 -L check failed"
    tunegfs2 -l "${LOOP_DEV}"  | grep -i "testlabel"
    CHECK_RESULT $? 0 0 "tunegfs2 -L label not set"
    if tunegfs2 -h | grep "\-r";then
        # Test -r option (set version)
        tunegfs2 -r 1802 "${LOOP_DEV}"
        CHECK_RESULT $? 0 0 "tunegfs2 -r check failed"
        tunegfs2 -l "${LOOP_DEV}"  | grep -i "1802"
        CHECK_RESULT $? 0 0 "tunegfs2 -r version not set"
    fi
    # Test -U option (set UUID)
    tunegfs2 -U 12345678-1234-1234-1234-123456789abc "${LOOP_DEV}"
    CHECK_RESULT $? 0 0 "tunegfs2 -U check failed"
    tunegfs2 -l "${LOOP_DEV}"  | grep -i "12345678-1234-1234-1234-123456789abc"
    CHECK_RESULT $? 0 0 "tunegfs2 -U UUID not set"
    # Test -o option (set mount options)
    tunegfs2 -o locktable=mycluster:myfs "${LOOP_DEV}"
    CHECK_RESULT $? 0 0 "tunegfs2 -o locktable check failed"
    tunegfs2 -l "${LOOP_DEV}" | grep "mycluster:myfs"
    CHECK_RESULT $? 0 0 "tunegfs2 -o locktable not effective"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    losetup -d "${LOOP_DEV}"
    rm -rf "${TEST_IMG}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"