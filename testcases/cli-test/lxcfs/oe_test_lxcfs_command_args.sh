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
# @Desc      :   Test lxcfs command line arguments
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "lxcfs fuse"
    killall lxcfs 2>/dev/null || true
    SLEEP_WAIT 1
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # -v/--version 版本信息输出
    lxcfs -v 2>&1 | grep -E '[0-9]+\.[0-9]+\.[0-9]+' > /dev/null
    CHECK_RESULT $? 0 0 "lxcfs -v failed"

    # --version 版本信息输出
    lxcfs --version 2>&1 | grep -E '[0-9]+\.[0-9]+\.[0-9]+' > /dev/null
    CHECK_RESULT $? 0 0 "lxcfs --version failed"

    # -h/--help 帮助信息输出
    lxcfs -h 2>&1 | grep -i "usage" > /dev/null
    CHECK_RESULT $? 0 0 "lxcfs -h failed"

    # --help 帮助信息输出
    lxcfs --help 2>&1 | grep -i "usage" > /dev/null
    CHECK_RESULT $? 0 0 "lxcfs --help failed"

    # -f/--foreground 前台模式运行
    mkdir -p /tmp/lxcfs_fg
    lxcfs -f /tmp/lxcfs_fg > /dev/null 2>&1 &
    lxcfs_pid=$!
    SLEEP_WAIT 2
    test -d /tmp/lxcfs_fg/proc
    CHECK_RESULT $? 0 0 "lxcfs -f (foreground) failed"
    kill -TERM "$lxcfs_pid" 2>/dev/null || true
    SLEEP_WAIT 1
    fusermount -u /tmp/lxcfs_fg 2>/dev/null || true
    rm -rf /tmp/lxcfs_fg

    # -p/--pidfile 指定PID文件路径
    mkdir -p /tmp/lxcfs_pidfile
    lxcfs -p /tmp/lxcfs.pid /tmp/lxcfs_pidfile &
    SLEEP_WAIT 2
    test -f /tmp/lxcfs.pid
    CHECK_RESULT $? 0 0 "lxcfs -p pid file not created"
    cat /tmp/lxcfs.pid | grep -E '^[0-9]+$' > /dev/null
    CHECK_RESULT $? 0 0 "lxcfs -p pid file content invalid"
    kill -TERM "$(cat /tmp/lxcfs.pid)" 2>/dev/null || true
    SLEEP_WAIT 1
    fusermount -u /tmp/lxcfs_pidfile 2>/dev/null || true
    rm -rf /tmp/lxcfs_pidfile

    # --pidfile=FILE 指定PID文件路径
    mkdir -p /tmp/lxcfs_pidfile2
    lxcfs --pidfile=/tmp/lxcfs2.pid /tmp/lxcfs_pidfile2 &
    SLEEP_WAIT 2
    test -f /tmp/lxcfs2.pid
    CHECK_RESULT $? 0 0 "lxcfs --pidfile pid file not created"
    cat /tmp/lxcfs2.pid | grep -E '^[0-9]+$' > /dev/null
    CHECK_RESULT $? 0 0 "lxcfs --pidfile pid file content invalid"
    kill -TERM "$(cat /tmp/lxcfs2.pid)" 2>/dev/null || true
    SLEEP_WAIT 1
    fusermount -u /tmp/lxcfs_pidfile2 2>/dev/null || true
    rm -rf /tmp/lxcfs_pidfile2

    # -d/--debug 调试模式运行
    mkdir -p /tmp/lxcfs_debug
    lxcfs -d -p /tmp/lxcfs_dbg.pid /tmp/lxcfs_debug &
    SLEEP_WAIT 2
    test -d /tmp/lxcfs_debug/proc
    CHECK_RESULT $? 0 0 "lxcfs -d (debug) failed"
    kill -TERM "$(cat /tmp/lxcfs_dbg.pid)" 2>/dev/null || true
    SLEEP_WAIT 1
    fusermount -u /tmp/lxcfs_debug 2>/dev/null || true
    rm -rf /tmp/lxcfs_debug

    # --debug 调试模式运行
    mkdir -p /tmp/lxcfs_debug2
    lxcfs --debug -p /tmp/lxcfs_dbg2.pid /tmp/lxcfs_debug2 &
    SLEEP_WAIT 2
    test -d /tmp/lxcfs_debug2/proc
    CHECK_RESULT $? 0 0 "lxcfs --debug failed"
    kill -TERM "$(cat /tmp/lxcfs_dbg2.pid)" 2>/dev/null || true
    SLEEP_WAIT 1
    fusermount -u /tmp/lxcfs_debug2 2>/dev/null || true
    rm -rf /tmp/lxcfs_debug2

    # -o FUSE选项传递
    mkdir -p /tmp/lxcfs_fuse
    lxcfs -o allow_other -f /tmp/lxcfs_fuse > /dev/null 2>&1 &
    lxcfs_pid=$!
    SLEEP_WAIT 2
    test -d /tmp/lxcfs_fuse/proc
    CHECK_RESULT $? 0 0 "lxcfs -o allow_other mount failed"
    kill -TERM "$lxcfs_pid" 2>/dev/null || true
    SLEEP_WAIT 1
    fusermount -u /tmp/lxcfs_fuse 2>/dev/null || true
    rm -rf /tmp/lxcfs_fuse

    # -l/--enable-loadavg 启用loadavg虚拟化
    mkdir -p /tmp/lxcfs_loadavg
    lxcfs -l -f /tmp/lxcfs_loadavg > /dev/null 2>&1 &
    lxcfs_pid=$!
    SLEEP_WAIT 2
    test -f /tmp/lxcfs_loadavg/proc/loadavg
    CHECK_RESULT $? 0 0 "lxcfs -l (enable-loadavg) failed"
    kill -TERM "$lxcfs_pid" 2>/dev/null || true
    SLEEP_WAIT 1
    fusermount -u /tmp/lxcfs_loadavg 2>/dev/null || true
    rm -rf /tmp/lxcfs_loadavg

    # --enable-loadavg 启用loadavg虚拟化
    mkdir -p /tmp/lxcfs_loadavg2
    lxcfs --enable-loadavg -p /tmp/lxcfs_lavg2.pid /tmp/lxcfs_loadavg2 &
    SLEEP_WAIT 2
    test -f /tmp/lxcfs_loadavg2/proc/loadavg
    CHECK_RESULT $? 0 0 "lxcfs --enable-loadavg failed"
    kill -TERM "$(cat /tmp/lxcfs_lavg2.pid)" 2>/dev/null || true
    SLEEP_WAIT 1
    fusermount -u /tmp/lxcfs_loadavg2 2>/dev/null || true
    rm -rf /tmp/lxcfs_loadavg2

    # -u/--disable-swap 禁用swap虚拟化
    mkdir -p /tmp/lxcfs_noswap
    lxcfs -u -p /tmp/lxcfs_noswap.pid /tmp/lxcfs_noswap &
    SLEEP_WAIT 2
    test -d /tmp/lxcfs_noswap/proc
    CHECK_RESULT $? 0 0 "lxcfs -u (disable-swap) failed"
    kill -TERM "$(cat /tmp/lxcfs_noswap.pid)" 2>/dev/null || true
    SLEEP_WAIT 1
    fusermount -u /tmp/lxcfs_noswap 2>/dev/null || true
    rm -rf /tmp/lxcfs_noswap

    # --disable-swap 禁用swap虚拟化
    mkdir -p /tmp/lxcfs_noswap2
    lxcfs --disable-swap -p /tmp/lxcfs_noswap2.pid /tmp/lxcfs_noswap2 &
    SLEEP_WAIT 2
    test -d /tmp/lxcfs_noswap2/proc
    CHECK_RESULT $? 0 0 "lxcfs --disable-swap failed"
    kill -TERM "$(cat /tmp/lxcfs_noswap2.pid)" 2>/dev/null || true
    SLEEP_WAIT 1
    fusermount -u /tmp/lxcfs_noswap2 2>/dev/null || true
    rm -rf /tmp/lxcfs_noswap2

    # --enable-cfs 通过CPU shares启用CPU虚拟化
    mkdir -p /tmp/lxcfs_cfs
    lxcfs --enable-cfs -p /tmp/lxcfs_cfs.pid /tmp/lxcfs_cfs &
    SLEEP_WAIT 2
    test -d /tmp/lxcfs_cfs/proc
    CHECK_RESULT $? 0 0 "lxcfs --enable-cfs failed"
    kill -TERM "$(cat /tmp/lxcfs_cfs.pid)" 2>/dev/null || true
    SLEEP_WAIT 1
    fusermount -u /tmp/lxcfs_cfs 2>/dev/null || true
    rm -rf /tmp/lxcfs_cfs

    # --enable-pidfd 使用pidfd进行进程追踪
    mkdir -p /tmp/lxcfs_pidfd
    lxcfs --enable-pidfd -p /tmp/lxcfs_pidfd.pid /tmp/lxcfs_pidfd &
    SLEEP_WAIT 2
    test -d /tmp/lxcfs_pidfd/proc
    CHECK_RESULT $? 0 0 "lxcfs --enable-pidfd failed"
    kill -TERM "$(cat /tmp/lxcfs_pidfd.pid)" 2>/dev/null || true
    SLEEP_WAIT 1
    fusermount -u /tmp/lxcfs_pidfd 2>/dev/null || true
    rm -rf /tmp/lxcfs_pidfd

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    killall lxcfs 2>/dev/null || true
    rm -rf /tmp/lxcfs*.pid /tmp/lxcfs_*.log
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"