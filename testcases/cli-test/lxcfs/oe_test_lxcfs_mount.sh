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
# @Date      :   2026-07-10
# @License   :   Mulan PSL v2
# @Desc      :   Test lxcfs FUSE mount functionality
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

MOUNT_POINT="/var/lib/lxcfs"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "lxcfs fuse"
    systemctl stop lxcfs.service 2>/dev/null || true
    rm -rf "$MOUNT_POINT"
    mkdir -p "$MOUNT_POINT"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    lxcfs "$MOUNT_POINT" &
    SLEEP_WAIT 2

    mount | grep -i "lxcfs" | grep -i "$MOUNT_POINT"
    CHECK_RESULT $? 0 0 "lxcfs is not mounted on $MOUNT_POINT"

    ls "$MOUNT_POINT"/proc/ > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "proc directory does not exist in lxcfs mount point"

    ls "$MOUNT_POINT"/sys/ > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "sys directory does not exist in lxcfs mount point"

    test -f "$MOUNT_POINT"/proc/cpuinfo
    CHECK_RESULT $? 0 0 "cpuinfo file does not exist"

    test -f "$MOUNT_POINT"/proc/meminfo
    CHECK_RESULT $? 0 0 "meminfo file does not exist"

    test -f "$MOUNT_POINT"/proc/stat
    CHECK_RESULT $? 0 0 "stat file does not exist"

    test -f "$MOUNT_POINT"/proc/uptime
    CHECK_RESULT $? 0 0 "uptime file does not exist"

    test -f "$MOUNT_POINT"/proc/swaps
    CHECK_RESULT $? 0 0 "swaps file does not exist"

    test -f "$MOUNT_POINT"/proc/diskstats
    CHECK_RESULT $? 0 0 "diskstats file does not exist"

    cat "$MOUNT_POINT"/proc/cpuinfo | grep -i "processor" > /dev/null
    CHECK_RESULT $? 0 0 "cpuinfo content is invalid"

    cat "$MOUNT_POINT"/proc/meminfo | grep -i "memtotal" > /dev/null
    CHECK_RESULT $? 0 0 "meminfo content is invalid"

    host_cpu_cores=$(grep -c "^processor" /proc/cpuinfo)
    lxcfs_cpu_cores=$(grep -c "^processor" "$MOUNT_POINT"/proc/cpuinfo)
    LOG_INFO "Host CPU cores: $host_cpu_cores, LXCFS CPU cores: $lxcfs_cpu_cores"
    test "$lxcfs_cpu_cores" -ge 1
    CHECK_RESULT $? 0 0 "lxcfs cpuinfo has no processors"

    host_mem_total=$(grep "^MemTotal" /proc/meminfo | awk '{print $2}')
    lxcfs_mem_total=$(grep "^MemTotal" "$MOUNT_POINT"/proc/meminfo | awk '{print $2}')
    LOG_INFO "Host MemTotal: ${host_mem_total}kB, LXCFS MemTotal: ${lxcfs_mem_total}kB"
    test "$lxcfs_mem_total" -gt 0
    CHECK_RESULT $? 0 0 "lxcfs meminfo MemTotal is zero or negative"

    cat "$MOUNT_POINT"/proc/meminfo | grep -i "MemFree" > /dev/null
    CHECK_RESULT $? 0 0 "meminfo MemFree is missing"

    cat "$MOUNT_POINT"/proc/meminfo | grep -i "MemAvailable" > /dev/null
    CHECK_RESULT $? 0 0 "meminfo MemAvailable is missing"

    cat "$MOUNT_POINT"/proc/meminfo | grep -i "Buffers" > /dev/null
    CHECK_RESULT $? 0 0 "meminfo Buffers is missing"

    cat "$MOUNT_POINT"/proc/meminfo | grep -i "Cached" > /dev/null
    CHECK_RESULT $? 0 0 "meminfo Cached is missing"

    fusermount -u "$MOUNT_POINT"
    CHECK_RESULT $? 0 0 "fusermount -u failed"

    mount | grep -i "lxcfs" | grep -i "$MOUNT_POINT" > /dev/null
    CHECK_RESULT $? 0 1 "lxcfs is still mounted after unmount"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    fusermount -u "$MOUNT_POINT" 2>/dev/null || true
    killall lxcfs 2>/dev/null || true
    rm -rf "$MOUNT_POINT"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"