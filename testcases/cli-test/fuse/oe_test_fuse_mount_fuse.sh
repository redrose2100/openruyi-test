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
# @Desc      :   Test mount.fuse command
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
    # 测试 mount.fuse 命令是否存在
    command -v mount.fuse
    CHECK_RESULT $? 0 0 "mount.fuse command not found"
    # mount.fuse命令：使用fuse2fs挂载ext4镜像文件到指定挂载点
    mount.fuse fuse2fs#"${FUSE_IMG}" "${FUSE_MNT}"
    CHECK_RESULT $? 0 0 "mount.fuse basic mount failed"
    mount | grep -q "${FUSE_MNT}"
    CHECK_RESULT $? 0 0 "mount.fuse mount verification failed"
    touch "${FUSE_MNT}/mount_fuse_test.txt"
    CHECK_RESULT $? 0 0 "file creation failed after mount.fuse"
    fusermount -u "${FUSE_MNT}"
    CHECK_RESULT $? 0 0 "fusermount -u unmount failed"
    # 测试 mount.fuse 使用 -o 选项挂载（allow_other）
    mount.fuse fuse2fs#"${FUSE_IMG}" "${FUSE_MNT}" -o allow_other
    CHECK_RESULT $? 0 0 "mount.fuse -o allow_other mount failed"
    mount | grep -q "${FUSE_MNT}"
    CHECK_RESULT $? 0 0 "mount.fuse -o allow_other mount verification failed"
    grep "${FUSE_MNT}" /proc/self/mountinfo | grep -q "allow_other"
    CHECK_RESULT $? 0 0 "allow_other option not effective"
    su -s /bin/sh -c "ls ${FUSE_MNT}" nobody
    CHECK_RESULT $? 0 0 "nobody user not can access the mount point"
    fusermount -u "${FUSE_MNT}"
    CHECK_RESULT $? 0 0 "fusermount -u unmount failed"
    # 测试 mount.fuse 使用 -o 选项挂载（allow_root）
    mount.fuse fuse2fs#"${FUSE_IMG}" "${FUSE_MNT}" -o allow_root
    CHECK_RESULT $? 0 0 "mount.fuse -o allow_root mount failed"
    mount | grep -q "${FUSE_MNT}"
    CHECK_RESULT $? 0 0 "mount.fuse -o allow_root mount verification failed"
    su -s /bin/sh -c "ls ${FUSE_MNT}" nobody
    CHECK_RESULT $? 0 1 "allow_root option not effective"
    fusermount -u "${FUSE_MNT}"
    CHECK_RESULT $? 0 0 "fusermount -u unmount failed"
    # 测试 mount.fuse 使用 -o 选项挂载（default_permissions）
    mount.fuse fuse2fs#"${FUSE_IMG}" "${FUSE_MNT}" -o default_permissions
    CHECK_RESULT $? 0 0 "mount.fuse -o default_permissions mount failed"
    mount | grep -q "${FUSE_MNT}"
    CHECK_RESULT $? 0 0 "mount.fuse -o default_permissions mount verification failed"
    grep "${FUSE_MNT}" /proc/self/mountinfo | grep -q "default_permissions"
    CHECK_RESULT $? 0 0 "default_permissions option not effective"
    # fusermount -u：卸载FUSE文件系统
    fusermount -u "${FUSE_MNT}"
    CHECK_RESULT $? 0 0 "fusermount -u unmount failed"
    # 测试 mount.fuse 使用 -o 选项挂载（ro只读模式）
    mount.fuse fuse2fs#"${FUSE_IMG}" "${FUSE_MNT}" -o ro
    CHECK_RESULT $? 0 0 "mount.fuse -o ro mount failed"
    mount | grep -q "${FUSE_MNT}"
    CHECK_RESULT $? 0 0 "mount.fuse -o ro mount verification failed"
    touch "${FUSE_MNT}/ro_test.txt" 2>/dev/null
    CHECK_RESULT $? 0 1 "read-only mount should not allow write"
    fusermount -u "${FUSE_MNT}"
    CHECK_RESULT $? 0 0 "fusermount -u unmount failed"
    # 测试 mount.fuse 使用 -o 选项挂载（rw读写模式）
    mount.fuse fuse2fs#"${FUSE_IMG}" "${FUSE_MNT}" -o rw
    CHECK_RESULT $? 0 0 "mount.fuse -o rw mount failed"
    mount | grep -q "${FUSE_MNT}"
    CHECK_RESULT $? 0 0 "mount.fuse -o rw mount verification failed"
    touch "${FUSE_MNT}/rw_test.txt"
    CHECK_RESULT $? 0 0 "read-write mount file creation failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    fusermount -u "${FUSE_MNT}"
    rm -rf "${FUSE_MNT}" "${FUSE_IMG}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"