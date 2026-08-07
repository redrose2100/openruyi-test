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
# @Desc      :   test gfs2_edit command
# ############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to config params of the case."
    TEST_IMG="/tmp/test_gfs2_edit_01.img"
    SAVE_FILE="/tmp/savergs_01.gz"
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
    gfs2_convert -h | grep -i "Usage"
    CHECK_RESULT $? 0 0 "gfs2_convert -h check failed"
    # Test -V option (version)
    gfs2_convert -V 2>&1 | grep -E "$(rpm -q gfs2-utils | awk -F '-' '{print $3}')|version"
    CHECK_RESULT $? 0 0 "gfs2_convert -V check failed"
    # Test -v option (verbose)
    gfs2_convert -v "${LOOP_DEV}" 2>&1 | grep "gfs1 filesystem"
    CHECK_RESULT $? 0 0 "gfs2_convert -v check failed"
    # Test -h option
    gfs2_edit -h 2>&1 | grep -i "Format"
    CHECK_RESULT $? 0 0 "gfs2_edit -h check failed"
    # Test -V option (version)
    gfs2_edit -V 2>&1 | grep -E "$(rpm -q gfs2-utils | awk -F '-' '{print $3}')|version"
    CHECK_RESULT $? 0 0 "gfs2_edit -V check failed"
    # Test rgcount option (print resource group count)
    gfs2_edit rgcount "${LOOP_DEV}" | grep -i "RG"
    CHECK_RESULT $? 0 0 "gfs2_edit rgcount check failed"
    # Test rgflags option (print flags for rg 0)
    gfs2_edit rgflags 0 "${LOOP_DEV}" | grep -i "flag"
    CHECK_RESULT $? 0 0 "gfs2_edit rgflags check failed"
    # Test -z 0 savergs option (save resource groups with no compression)
    gfs2_edit -z 0 savergs "${LOOP_DEV}" "${SAVE_FILE}"
    test -s "${SAVE_FILE}"
    CHECK_RESULT $? 0 0 "gfs2_edit -z 0 savergs check failed"
    # Test -c 1 option (alternate color scheme)
    gfs2_edit -c 1 -p sb "${LOOP_DEV}" | grep -i "Block #1"
    CHECK_RESULT $? 0 0 "gfs2_edit -c 1 check failed"
    # Test -s root option (specify starting block)
    gfs2_edit -s root -p sb "${LOOP_DEV}" | grep -i "Block #16"
    CHECK_RESULT $? 0 0 "gfs2_edit -s root check failed"
    # Test -x option (print in hex mode)
    gfs2_edit -x -p sb "${LOOP_DEV}" | grep -E "^[0-9a-f]{8} [0-9a-f]{8}"
    CHECK_RESULT $? 0 0 "gfs2_edit -x check failed"
    # Test -d -p journals option (print journal status with details)
    gfs2_edit -d -p journals "${LOOP_DEV}" | grep -i "Journal"
    CHECK_RESULT $? 0 0 "gfs2_edit -d -p journals check failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    losetup -d "${LOOP_DEV}"
    rm -rf "${TEST_IMG}" "${SAVE_FILE}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
