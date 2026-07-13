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
# @Desc      :   Test fusermount command options
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
    mkfs.ext4 -F "${FUSE_IMG}" >/dev/null 2>&1
    modprobe fuse 2>/dev/null
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # 测试选项 -h / --help：显示帮助信息
    fusermount -h 2>&1 | grep -i "fusermount"
    CHECK_RESULT $? 0 0 "fusermount -h failed"
    # fusermount命令：显示帮助信息（长选项）
    fusermount --help 2>&1 | grep -i "fusermount"
    CHECK_RESULT $? 0 0 "fusermount --help failed"
    # 测试选项 -V / --version：显示版本信息
    fusermount -V | grep -i "version"
    CHECK_RESULT $? 0 0 "fusermount -V failed"
    # fusermount命令：显示版本信息（长选项）
    fusermount --version | grep -i "version"
    CHECK_RESULT $? 0 0 "fusermount --version failed"
    fuse2fs "${FUSE_IMG}" "${FUSE_MNT}"
    CHECK_RESULT $? 0 0 "fuse2fs mount failed, cannot proceed with unmount tests"
    # fusermount -u：卸载FUSE文件系统
    fusermount -u "${FUSE_MNT}"
    CHECK_RESULT $? 0 0 "fusermount -u failed"
    mount | grep -q "${FUSE_MNT}"
    CHECK_RESULT $? 0 1 "mount point still exists after fusermount -u"
    fuse2fs "${FUSE_IMG}" "${FUSE_MNT}"
    CHECK_RESULT $? 0 0 "fuse2fs mount failed"
    # fusermount -uq：以静默模式卸载FUSE文件系统
    output=$(fusermount -uq "${FUSE_MNT}" 2>&1)
    CHECK_RESULT $? 0 0 "fusermount -uq failed"
    [ -z "${output}" ]
    CHECK_RESULT $? 0 0 "quiet mode should have no output"
    fuse2fs "${FUSE_IMG}" "${FUSE_MNT}"
    CHECK_RESULT $? 0 0 "fuse2fs mount failed"
    current_path=$(
        cd "$(dirname "$0")" || exit 1
        pwd
    )
    cd "${FUSE_MNT}" || exit 1
    # fusermount -uz：组合选项，延迟卸载
    fusermount -u "${FUSE_MNT}" 2>&1 | grep -i "failed to unmount.*Device or resource busy"
    CHECK_RESULT $? 0 0 "fusermount -u failed"
    fusermount -uz "${FUSE_MNT}"
    CHECK_RESULT $? 0 0 "fusermount -uz failed"
    cd "${current_path}" || exit 1
    SLEEP_WAIT 1
    mount | grep -q "${FUSE_MNT}"
    CHECK_RESULT $? 0 1 "mount point still exists after fusermount -uz"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    fusermount -zu "${FUSE_MNT}"
    rm -rf "${FUSE_MNT}" "${FUSE_IMG}"
    umount /sys/fs/fuse/connections
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"