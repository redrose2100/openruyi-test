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
# @Author    :   ding-jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2026-07-14
# @License   :   Mulan PSL v2
# @Desc      :   Test lxcfs FUSE mount and unmount functionality
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

MOUNT_POINT="/tmp/lxcfs_mount_test"


function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "lxcfs fuse"
    systemctl stop lxcfs.service 2>/dev/null || true
    fusermount -u "$MOUNT_POINT" 2>/dev/null || true
    rm -rf "$MOUNT_POINT"
    mkdir -p "$MOUNT_POINT"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # 启动lxcfs并挂载到指定目录
    lxcfs "$MOUNT_POINT" &
    SLEEP_WAIT 2

    # 验证lxcfs是否成功挂载
    mount | grep -q "lxcfs.*$MOUNT_POINT"
    CHECK_RESULT $? 0 0 "lxcfs is not mounted on $MOUNT_POINT"

    # 验证proc目录存在
    test -d "$MOUNT_POINT/proc"
    CHECK_RESULT $? 0 0 "proc directory does not exist in lxcfs mount point"

    # 验证sys目录存在
    test -d "$MOUNT_POINT/sys"
    CHECK_RESULT $? 0 0 "sys directory does not exist in lxcfs mount point"

    # 验证cgroup目录存在
    test -d "$MOUNT_POINT/cgroup"
    CHECK_RESULT $? 0 0 "cgroup directory does not exist in lxcfs mount point"

    # 卸载lxcfs挂载
    fusermount -u "$MOUNT_POINT"
    CHECK_RESULT $? 0 0 "fusermount -u failed"

    # 验证挂载点已卸载
    mount | grep -q "lxcfs.*$MOUNT_POINT"
    CHECK_RESULT $? 1 0 "lxcfs is still mounted after unmount"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    killall lxcfs 2>/dev/null || true
    fusermount -u "$MOUNT_POINT" 2>/dev/null || true
    rm -rf "$MOUNT_POINT"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
