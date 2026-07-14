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
# @Desc      :   Test lxcfs /proc virtualization (cpuinfo, meminfo, loadavg, swaps, stat, uptime, diskstats)
# #############################################
# shellcheck disable=SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

MOUNT_POINT="/tmp/lxcfs_virt_test"

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

    lxcfs "$MOUNT_POINT" &
    SLEEP_WAIT 2

    # 验证cpuinfo文件存在
    test -f "$MOUNT_POINT/proc/cpuinfo"
    CHECK_RESULT $? 0 0 "cpuinfo file does not exist"

    # 验证cpuinfo包含processor字段
    grep -q "^processor" "$MOUNT_POINT/proc/cpuinfo"
    CHECK_RESULT $? 0 0 "cpuinfo has no processor field"

    # 验证meminfo文件存在
    test -f "$MOUNT_POINT/proc/meminfo"
    CHECK_RESULT $? 0 0 "meminfo file does not exist"

    # 验证meminfo包含MemTotal字段
    grep -q "^MemTotal" "$MOUNT_POINT/proc/meminfo"
    CHECK_RESULT $? 0 0 "meminfo MemTotal is missing"

    # 验证meminfo包含MemFree字段
    grep -q "^MemFree" "$MOUNT_POINT/proc/meminfo"
    CHECK_RESULT $? 0 0 "meminfo MemFree is missing"

    # 验证虚拟化meminfo值有效
    VIRT_MEM=$(grep "^MemTotal:" "$MOUNT_POINT/proc/meminfo" | awk '{print $2}')
    test -n "$VIRT_MEM" && test "$VIRT_MEM" -gt 0
    CHECK_RESULT $? 0 0 "Virtualized MemTotal is empty or invalid"

    # 验证loadavg文件存在
    test -f "$MOUNT_POINT/proc/loadavg"
    CHECK_RESULT $? 0 0 "loadavg file does not exist"

    # 验证loadavg内容格式正确
    grep -qE '^[0-9.]+ [0-9.]+ [0-9.]+' "$MOUNT_POINT/proc/loadavg"
    CHECK_RESULT $? 0 0 "loadavg content is invalid"

    # 验证swaps文件存在
    test -f "$MOUNT_POINT/proc/swaps"
    CHECK_RESULT $? 0 0 "swaps file does not exist"

    # 验证swaps表头存在
    grep -q "^Filename" "$MOUNT_POINT/proc/swaps"
    CHECK_RESULT $? 0 0 "swaps header is missing"

    # 验证stat文件存在
    test -f "$MOUNT_POINT/proc/stat"
    CHECK_RESULT $? 0 0 "stat file does not exist"

    # 验证stat包含cpu行
    grep -q "^cpu " "$MOUNT_POINT/proc/stat"
    CHECK_RESULT $? 0 0 "stat missing cpu line"

    # 验证uptime文件存在
    test -f "$MOUNT_POINT/proc/uptime"
    CHECK_RESULT $? 0 0 "uptime file does not exist"

    # 验证uptime内容有效
    grep -qE '^[0-9.]+ [0-9.]+' "$MOUNT_POINT/proc/uptime"
    CHECK_RESULT $? 0 0 "uptime content is invalid"

    # 验证diskstats文件存在
    test -f "$MOUNT_POINT/proc/diskstats"
    CHECK_RESULT $? 0 0 "diskstats file does not exist"

    # 卸载lxcfs挂载
    fusermount -u "$MOUNT_POINT"
    CHECK_RESULT $? 0 0 "fusermount -u failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    killall lxcfs 2>/dev/null || true
    fusermount -u "$MOUNT_POINT" 2>/dev/null || true
    rm -rf "$MOUNT_POINT"
    systemctl start lxcfs.service 2>/dev/null || true
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
