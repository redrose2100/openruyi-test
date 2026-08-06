#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   ding_jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2026-08-05
# @License   :   Mulan PSL v2
# @Desc      :   Test libnftnl package installation completeness and nft command basic functionality
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libnftnl nftables"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test libnftnl_install: Verify libnftnl package is installed
    rpm -q libnftnl > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "libnftnl package not installed"

    # Test libnftnl_version: Check libnftnl package version
    libnftnl_ver=$(rpm -q libnftnl --qf "%{VERSION}" 2>/dev/null)
    [ -n "$libnftnl_ver" ]
    CHECK_RESULT $? 0 0 "libnftnl version not found"

    # Test libnftnl_files: Verify all expected package files exist
    file_count=$(rpm -ql libnftnl 2>/dev/null | wc -l)
    [ "$file_count" -gt 0 ]
    CHECK_RESULT $? 0 0 "libnftnl package files missing"

    # Test libnftnl_so_file: Verify shared library file exists
    ls /usr/lib64/libnftnl.so* > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "libnftnl.so not found"

    # Test libnftnl_soname: Verify SONAME version
    soname=$(readlink -f /usr/lib64/libnftnl.so.11 2>/dev/null)
    [ -n "$soname" ]
    CHECK_RESULT $? 0 0 "libnftnl.so.11 not found"

    # Test libnftnl_soname_link: Verify .so symlink points to real file
    real_file=$(readlink -f /usr/lib64/libnftnl.so.11 2>/dev/null)
    [ -f "$real_file" ]
    CHECK_RESULT $? 0 0 "libnftnl.so.11 symlink broken"

    # Test nftables_install: Verify nftables package is installed
    rpm -q nftables > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "nftables package not installed"

    # Test nftables_version: Check nftables package version
    nftables_ver=$(rpm -q nftables --qf "%{VERSION}" 2>/dev/null)
    [ -n "$nftables_ver" ]
    CHECK_RESULT $? 0 0 "nftables version not found"

    # Test nftables_files: Verify nftables package files
    rpm -ql nftables | grep "/usr/sbin/nft" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "nft binary not in nftables package"

    # Test nft_exists: Verify nft command exists
    which nft > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "nft command not found"

    # Test nft_executable: Verify nft binary is executable
    [ -x /usr/sbin/nft ]
    CHECK_RESULT $? 0 0 "nft binary not executable"

    # Test nft_help: Show nft help
    nft --help > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "nft --help failed"

    # Test nft_version: Show nft version
    nft --version | grep "nftables"
    CHECK_RESULT $? 0 0 "nft --version failed"

    # Test nft_V: Show extended version
    nft -V > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "nft -V failed"

    # Test libnftnl_ldd: Verify libnftnl is linked by nft
    ldd /usr/sbin/nft 2>/dev/null | grep "libnftnl"
    CHECK_RESULT $? 0 0 "nft binary not linked to libnftnl"

    # Test libmnl_ldd: Verify libmnl is linked by nft
    ldd /usr/sbin/nft 2>/dev/null | grep "libmnl"
    CHECK_RESULT $? 0 0 "nft binary not linked to libmnl"

    # Test json_output: JSON format output
    nft -j list ruleset > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "nft JSON output failed"

    # Test check_mode: Check mode (-c) validates without applying
    echo "add table inet libnftnl_check" | nft -c -f - > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "nft check mode failed"

    # Test handle_option: Show rule handles
    nft -a list ruleset > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "nft handle option failed"

    # Test echo_option: Echo added rules
    nft add table inet libnftnl_echo -e 2>&1 | grep "libnftnl_echo"
    CHECK_RESULT $? 0 0 "nft echo option failed"

    # Test invalid_command: Invalid command should fail
    nft invalid_cmd 2>&1 | grep -qi "error\|invalid"
    CHECK_RESULT $? 0 0 "nft invalid command should report error"

    # Test flush_ruleset: Flush ruleset
    nft delete table inet libnftnl_echo 2>/dev/null
    nft flush ruleset > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "nft flush ruleset failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    nft delete table inet libnftnl_echo 2>/dev/null
    nft flush ruleset 2>/dev/null
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
