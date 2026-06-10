#!/usr/bin/bash
# Copyright (c) 2026.Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   yourname
# @Contact   :   youremail@example.com
# @Date      :   2026-6-10
# @License   :   Mulan PSL v2
# @Desc      :   Command fsck.fat comprehensive test
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "dosfstools"
    TEST_IMG="/tmp/test_fat32.img"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing fsck.fat comprehensive functions..."
    dd if=/dev/zero of=${TEST_IMG} bs=1M count=50 >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "Create FAT32 image file failed"

    mkfs.vfat -F 32 ${TEST_IMG} >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "Format to FAT32 failed"

    LOG_INFO "Test 1: Basic check (-n option)"
    fsck.fat -n ${TEST_IMG} >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "fsck.fat -n basic check failed"

    LOG_INFO "Test 2: Verbose mode (-v -n option)"
    fsck.fat -v -n ${TEST_IMG} >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "fsck.fat -v verbose mode failed"

    LOG_INFO "Test 3: Verify mode (-V -n option)"
    fsck.fat -V -n ${TEST_IMG} >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "fsck.fat -V verify mode failed"

    LOG_INFO "Test 4: List files (-l -n option)"
    fsck.fat -l -n ${TEST_IMG} >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "fsck.fat -l list files failed"

    LOG_INFO "Test 5: Auto repair (-a option)"
    fsck.fat -a ${TEST_IMG} >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "fsck.fat -a auto repair failed"

    LOG_INFO "Test 6: Bad clusters test (-t option)"
    fsck.fat -t ${TEST_IMG} >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "fsck.fat -t bad clusters test failed"

    LOG_INFO "Finish fsck.fat comprehensive test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ${TEST_IMG}
    #shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
