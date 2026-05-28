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
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2026-5-28
# @License   :   Mulan PSL v2
# @Desc      :   Command fsck.ext3 test
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    TMP_IMG="/tmp/tmp_ext3.img"
    BAD_BLOCK_FILE="/tmp/bad_blocks.list"
    UNDO_FILE="/tmp/fsck_undo.gz"
    LOG_FILE="/tmp/fsck_ext3_test.log"
    LOG_INFO "End to prepare the test environment."
}


function run_test() {
    LOG_INFO "Start testing fsck.ext3 parameters..."
    sleep 1
    dd if=/dev/zero of=${TMP_IMG} bs=1M count=5 >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "Create ext3 image file failed"
    mkfs.ext3 -F ${TMP_IMG} >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "Format to ext3 failed"
    fsck.ext3 -n ${TMP_IMG}
    CHECK_RESULT $? 0 0 "fsck.ext3 -n failed"
    fsck.ext3 -p ${TMP_IMG}
    CHECK_RESULT $? 0 0 "fsck.ext3 -p failed"
    fsck.ext3 -y -v ${TMP_IMG} >${LOG_FILE} 2>&1
    CHECK_RESULT $? 0 0 "fsck.ext3 -y -v failed"
    fsck.ext3 -n -B 1024 ${TMP_IMG}
    CHECK_RESULT $? 0 0 "fsck.ext3 -B failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ${TMP_IMG} ${BAD_BLOCK_FILE} ${UNDO_FILE} ${LOG_FILE}
    LOG_INFO "End to restore the test environment."
}

main "$@"
