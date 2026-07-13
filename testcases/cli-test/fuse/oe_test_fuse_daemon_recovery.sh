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
# @Date      :   2026/07/13
# @License   :   Mulan PSL v2
# @Desc      :   Test daemon crash recovery and remount
# ############################################

# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function config_params() {
    LOG_INFO "Start to config params of the case."
    FUSE_MNT="/tmp/fuse_mnt_$(date +%s)"
    FUSE_IMG="/tmp/fuse_img_$(date +%s)"
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "fuse e2fsprogs"
    mkdir -p "${FUSE_MNT}"
    dd if=/dev/zero of="${FUSE_IMG}" bs=1M count=5 2>/dev/null
    mkfs.ext2 -F "${FUSE_IMG}" >/dev/null 2>&1
    modprobe fuse 2>/dev/null
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # 启动fuse daemon并执行文件操作
    fuse2fs "${FUSE_IMG}" "${FUSE_MNT}"
    CHECK_RESULT $? 0 0 "fuse2fs mount failed"
    echo "test_data_before_crash" > "${FUSE_MNT}/crash_test.txt"
    CHECK_RESULT $? 0 0 "file creation failed during normal operation"
    # 正常卸载
    fusermount -u "${FUSE_MNT}"
    CHECK_RESULT $? 0 0 "fusermount -u unmount failed"
    # 重新挂载和数据恢复
    fuse2fs "${FUSE_IMG}" "${FUSE_MNT}"
    CHECK_RESULT $? 0 0 "remount failed - data recovery failed"
    [ -f "${FUSE_MNT}/crash_test.txt" ]
    CHECK_RESULT $? 0 0 "crash_test.txt missing after recovery"
    grep -q "test_data_before_crash" "${FUSE_MNT}/crash_test.txt"
    CHECK_RESULT $? 0 0 "crash_test.txt content corrupted after recovery"
    # 创建新文件验证恢复后的写入能力
    echo "new_data_after_recovery" > "${FUSE_MNT}/new_after_recovery.txt"
    CHECK_RESULT $? 0 0 "file creation failed after recovery"
    grep -q "new_data_after_recovery" "${FUSE_MNT}/new_after_recovery.txt"
    CHECK_RESULT $? 0 0 "new file content corrupted"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    pkill fuse2fs
    fusermount -uz "${FUSE_MNT}"
    rm -rf "${FUSE_MNT}" "${FUSE_IMG}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"