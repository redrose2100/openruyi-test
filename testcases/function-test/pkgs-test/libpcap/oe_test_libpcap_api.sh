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
# @Date      :   2026-08-04
# @License   :   Mulan PSL v2
# @Desc      :   libpcap API functionality test - compile and run test program
# ############################################
# shellcheck disable=SC1090,SC2119,SC2046
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libpcap libpcap-devel gcc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    local test_dir
    local output
    local ret_code
    test_dir="$(dirname "$0")"

    # Step 1: Compile the test program using pkg-config flags
    gcc -o /tmp/pcap_test "${test_dir}/pcap_test.c" $(pkg-config --cflags --libs libpcap) 2>&1
    CHECK_RESULT $? 0 0 "Failed to compile pcap_test.c"

    # Step 2: Verify compiled binary exists
    test -x /tmp/pcap_test
    CHECK_RESULT $? 0 0 "pcap_test binary not found"

    # Step 3: Verify pkg-config exposes the libpcap library
    pkg-config --cflags --libs libpcap > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "pkg-config for libpcap failed"

    # Step 4: Ensure libpcap header file exists (location varies by distro)
    local header_path
    header_path=$(pkg-config --cflags-only-I libpcap 2>/dev/null | sed 's/-I//')
    if [ -n "$header_path" ] && [ -f "${header_path}/pcap.h" ]; then
        CHECK_RESULT 0 0 0 "libpcap header file found via pkg-config"
    elif [ -f /usr/include/pcap/pcap.h ]; then
        CHECK_RESULT 0 0 0 "libpcap header file found at /usr/include/pcap/pcap.h"
    elif [ -f /usr/include/pcap.h ]; then
        CHECK_RESULT 0 0 0 "libpcap header file found at /usr/include/pcap.h"
    else
        CHECK_RESULT 1 0 0 "libpcap header file not found"
    fi

    # Capture output and exit code separately to avoid pipefail issues
    output=$(/tmp/pcap_test 2>&1)
    ret_code=$?

    # Step 5: Verify program exited successfully
    CHECK_RESULT $ret_code 0 0 "pcap_test program failed"

    # Step 6: Verify pcap_lib_version API returned valid string
    echo "$output" | grep -q "pcap_lib_version() returned valid string"
    CHECK_RESULT $? 0 0 "pcap_lib_version() API test failed"

    # Step 7: Verify pcap_findalldevs API succeeded
    echo "$output" | grep -q "pcap_findalldevs() succeeded"
    CHECK_RESULT $? 0 0 "pcap_findalldevs() API test failed"

    # Step 8: Verify at least one interface was discovered
    echo "$output" | grep -q "At least one interface found"
    CHECK_RESULT $? 0 0 "Interface discovery test failed"

    # Step 9: Verify pcap_open_live API succeeded
    echo "$output" | grep -q 'pcap_open_live("lo") succeeded'
    CHECK_RESULT $? 0 0 "pcap_open_live() API test failed"

    # Step 10: Verify pcap_compile / pcap_setfilter APIs succeeded
    echo "$output" | grep -q "pcap_compile() compiled BPF filter"
    CHECK_RESULT $? 0 0 "pcap_compile() API test failed"

    echo "$output" | grep -q "pcap_setfilter() installed BPF filter"
    CHECK_RESULT $? 0 0 "pcap_setfilter() API test failed"

    # Step 11: Verify pcap_dispatch captured packets
    echo "$output" | grep -q "pcap_dispatch() captured packets"
    CHECK_RESULT $? 0 0 "pcap_dispatch() API test failed"

    echo "$output" | grep -q "all tests passed"
    CHECK_RESULT $? 0 0 "pcap_test summary reports failed tests"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f /tmp/pcap_test
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
