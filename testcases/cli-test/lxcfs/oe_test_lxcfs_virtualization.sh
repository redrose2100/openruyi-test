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
# @Date      :   2026-07-13
# @License   :   Mulan PSL v2
# @Desc      :   Test lxcfs /proc virtualization (cpuinfo, meminfo, loadavg, swaps)
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

    test -f "$MOUNT_POINT"/proc/cpuinfo
    CHECK_RESULT $? 0 0 "cpuinfo file does not exist"

    grep "^processor" "$MOUNT_POINT"/proc/cpuinfo > /dev/null
    CHECK_RESULT $? 0 0 "cpuinfo has no processor field"

    test -f "$MOUNT_POINT"/proc/meminfo
    CHECK_RESULT $? 0 0 "meminfo file does not exist"

    grep "^MemTotal" "$MOUNT_POINT"/proc/meminfo | grep -E '[0-9]+' > /dev/null
    CHECK_RESULT $? 0 0 "meminfo MemTotal is missing or invalid"

    test -f "$MOUNT_POINT"/proc/loadavg
    CHECK_RESULT $? 0 0 "loadavg file does not exist"

    cat "$MOUNT_POINT"/proc/loadavg | grep -E '^[0-9.]+ [0-9.]+ [0-9.]+' > /dev/null
    CHECK_RESULT $? 0 0 "loadavg content is invalid"

    test -f "$MOUNT_POINT"/proc/swaps
    CHECK_RESULT $? 0 0 "swaps file does not exist"

    cat "$MOUNT_POINT"/proc/swaps | grep -E '^Filename|^/' > /dev/null
    CHECK_RESULT $? 0 0 "swaps content is invalid"

    test -f "$MOUNT_POINT"/proc/stat
    CHECK_RESULT $? 0 0 "stat file does not exist"

    test -f "$MOUNT_POINT"/proc/uptime
    CHECK_RESULT $? 0 0 "uptime file does not exist"

    test -f "$MOUNT_POINT"/proc/diskstats
    CHECK_RESULT $? 0 0 "diskstats file does not exist"

    fusermount -u "$MOUNT_POINT"
    CHECK_RESULT $? 0 0 "fusermount -u failed"

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