#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zjl_long
# @Contact   :   zhu_jinlong@hoperun.com
# @Date      :   2026-08-03
# @License   :   Mulan PSL v2
# @Desc      :   libnetfilter_queue-devel header files and pkg-config verification
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libnetfilter_queue libnetfilter_queue-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Step 1: Verify libnetfilter_queue-devel package is installed
    rpm -qa | grep -w libnetfilter_queue-devel
    CHECK_RESULT $? 0 0 "libnetfilter_queue-devel package not installed"

    # Step 2: Verify main header file exists
    test -f /usr/include/libnetfilter_queue/libnetfilter_queue.h
    CHECK_RESULT $? 0 0 "libnetfilter_queue.h header not found"

    # Step 3: Verify linux_nfnetlink_queue.h header exists
    test -f /usr/include/libnetfilter_queue/linux_nfnetlink_queue.h
    CHECK_RESULT $? 0 0 "linux_nfnetlink_queue.h header not found"

    # Step 4: Verify pktbuff.h header exists
    test -f /usr/include/libnetfilter_queue/pktbuff.h
    CHECK_RESULT $? 0 0 "pktbuff.h header not found"

    # Step 5: Verify libnetfilter_queue_ipv4.h header exists
    test -f /usr/include/libnetfilter_queue/libnetfilter_queue_ipv4.h
    CHECK_RESULT $? 0 0 "libnetfilter_queue_ipv4.h header not found"

    # Step 6: Verify libnetfilter_queue_tcp.h header exists
    test -f /usr/include/libnetfilter_queue/libnetfilter_queue_tcp.h
    CHECK_RESULT $? 0 0 "libnetfilter_queue_tcp.h header not found"

    # Step 7: Verify pkg-config file exists
    test -f /usr/lib64/pkgconfig/libnetfilter_queue.pc
    CHECK_RESULT $? 0 0 "libnetfilter_queue.pc pkg-config file not found"

    # Step 8: Verify pkg-config --modversion works
    pkg-config --modversion libnetfilter_queue > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "pkg-config --modversion libnetfilter_queue failed"

    # Step 9: Verify pkg-config --cflags returns successfully
    pkg-config --cflags libnetfilter_queue > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "pkg-config --cflags libnetfilter_queue failed"

    # Step 10: Verify pkg-config --libs returns link flags
    pkg-config --libs libnetfilter_queue > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "pkg-config --libs libnetfilter_queue failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
