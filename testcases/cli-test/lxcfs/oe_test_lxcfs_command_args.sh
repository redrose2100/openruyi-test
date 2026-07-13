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
# @Desc      :   Test lxcfs command line arguments
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "lxcfs fuse"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    lxcfs -v 2>&1 | grep -E '[0-9]+\.[0-9]+\.[0-9]+' > /dev/null
    CHECK_RESULT $? 0 0 "lxcfs -v failed"

    lxcfs --version 2>&1 | grep -E '[0-9]+\.[0-9]+\.[0-9]+' > /dev/null
    CHECK_RESULT $? 0 0 "lxcfs --version failed"

    lxcfs -h 2>&1 | grep -i "usage" > /dev/null
    CHECK_RESULT $? 0 0 "lxcfs -h failed"

    lxcfs --help 2>&1 | grep -i "usage" > /dev/null
    CHECK_RESULT $? 0 0 "lxcfs --help failed"

    mkdir -p /tmp/lxcfs_test1
    lxcfs -f /tmp/lxcfs_test1 > /tmp/lxcfs_fg.log 2>&1 &
    lxcfs_pid=$!
    SLEEP_WAIT 2

    kill -TERM "$lxcfs_pid" 2>/dev/null || true
    SLEEP_WAIT 1

    fusermount -u /tmp/lxcfs_test1 2>/dev/null || true

    mkdir -p /tmp/lxcfs_test3
    lxcfs -p /tmp/lxcfs.pid /tmp/lxcfs_test3 &
    SLEEP_WAIT 2

    test -f /tmp/lxcfs.pid
    CHECK_RESULT $? 0 0 "lxcfs -p pid file not created"

    cat /tmp/lxcfs.pid | grep -E '^[0-9]+$' > /dev/null
    CHECK_RESULT $? 0 0 "lxcfs -p pid file content invalid"

    kill -TERM "$(cat /tmp/lxcfs.pid)" 2>/dev/null || true
    SLEEP_WAIT 1
    fusermount -u /tmp/lxcfs_test3 2>/dev/null || true

    mkdir -p /tmp/lxcfs_test4
    lxcfs --pidfile=/tmp/lxcfs2.pid /tmp/lxcfs_test4 &
    SLEEP_WAIT 2

    test -f /tmp/lxcfs2.pid
    CHECK_RESULT $? 0 0 "lxcfs --pidfile pid file not created"

    cat /tmp/lxcfs2.pid | grep -E '^[0-9]+$' > /dev/null
    CHECK_RESULT $? 0 0 "lxcfs --pidfile pid file content invalid"

    kill -TERM "$(cat /tmp/lxcfs2.pid)" 2>/dev/null || true
    SLEEP_WAIT 1
    fusermount -u /tmp/lxcfs_test4 2>/dev/null || true

    mkdir -p /tmp/lxcfs_test5
    lxcfs -d -f /tmp/lxcfs_test5 > /tmp/lxcfs_debug.log 2>&1 &
    lxcfs_pid=$!
    SLEEP_WAIT 2

    kill -TERM "$lxcfs_pid" 2>/dev/null || true
    SLEEP_WAIT 1
    fusermount -u /tmp/lxcfs_test5 2>/dev/null || true

    mkdir -p /tmp/lxcfs_test6
    lxcfs --debug -f /tmp/lxcfs_test6 > /tmp/lxcfs_debug2.log 2>&1 &
    lxcfs_pid=$!
    SLEEP_WAIT 2

    kill -TERM "$lxcfs_pid" 2>/dev/null || true
    SLEEP_WAIT 1
    fusermount -u /tmp/lxcfs_test6 2>/dev/null || true

    mkdir -p /tmp/lxcfs_test7
    lxcfs -o allow_other -f /tmp/lxcfs_test7 > /tmp/lxcfs_fuse.log 2>&1 &
    lxcfs_pid=$!
    SLEEP_WAIT 2

    mount | grep -i "/tmp/lxcfs_test7" | grep -i "allow_other" > /dev/null
    CHECK_RESULT $? 0 0 "lxcfs -o allow_other failed"

    kill -TERM "$lxcfs_pid" 2>/dev/null || true
    SLEEP_WAIT 1
    fusermount -u /tmp/lxcfs_test7 2>/dev/null || true

    mkdir -p /tmp/lxcfs_test8
    lxcfs --enable-pidfd -f /tmp/lxcfs_test8 > /tmp/lxcfs_pidfd.log 2>&1 &
    lxcfs_pid=$!
    SLEEP_WAIT 2

    test -d /tmp/lxcfs_test8/proc
    CHECK_RESULT $? 0 0 "lxcfs --enable-pidfd failed"

    kill -TERM "$lxcfs_pid" 2>/dev/null || true
    SLEEP_WAIT 1
    fusermount -u /tmp/lxcfs_test8 2>/dev/null || true

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    killall lxcfs 2>/dev/null || true
    for i in 1 3 4 5 6 7 8; do
        fusermount -u /tmp/lxcfs_test${i} 2>/dev/null || true
        rm -rf /tmp/lxcfs_test${i}
    done
    rm -rf /tmp/lxcfs.pid /tmp/lxcfs2.pid /tmp/lxcfs_*.log
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"