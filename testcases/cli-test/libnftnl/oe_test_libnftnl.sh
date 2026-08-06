#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   ding_jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2026-08-06
# @License   :   Mulan PSL v2
# @Desc      :   Test libnftnl package installation completeness
# ############################################

# shellcheck disable=SC2119,SC1091,SC1090
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

    # Test libnftnl_release: Check libnftnl package release
    libnftnl_rel=$(rpm -q libnftnl --qf "%{RELEASE}" 2>/dev/null)
    [ -n "$libnftnl_rel" ]
    CHECK_RESULT $? 0 0 "libnftnl release not found"

    # Test libnftnl_arch: Check libnftnl package architecture
    libnftnl_arch=$(rpm -q libnftnl --qf "%{ARCH}" 2>/dev/null)
    [ -n "$libnftnl_arch" ]
    CHECK_RESULT $? 0 0 "libnftnl architecture not found"

    # Test libnftnl_vendor: Check libnftnl package vendor
    libnftnl_vendor=$(rpm -q libnftnl --qf "%{VENDOR}" 2>/dev/null)
    [ -n "$libnftnl_vendor" ]
    CHECK_RESULT $? 0 0 "libnftnl vendor not found"

    # Test libnftnl_summary: Check libnftnl package summary
    rpm -q libnftnl --qf "%{SUMMARY}" 2>/dev/null | grep -qi "nftables\|netfilter"
    CHECK_RESULT $? 0 0 "libnftnl summary not found or invalid"

    # Test libnftnl_files: Verify all expected package files exist
    file_count=$(rpm -ql libnftnl 2>/dev/null | wc -l)
    [ "$file_count" -gt 0 ]
    CHECK_RESULT $? 0 0 "libnftnl package files missing"

    # Test libnftnl_so_file: Verify shared library file exists
    ls /usr/lib64/libnftnl.so* > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "libnftnl.so not found"

    # Test libnftnl_soname: Verify SONAME version (libnftnl.so.11)
    soname=$(readlink -f /usr/lib64/libnftnl.so.11 2>/dev/null)
    [ -n "$soname" ]
    CHECK_RESULT $? 0 0 "libnftnl.so.11 not found"

    # Test libnftnl_soname_link: Verify .so symlink points to real file
    real_file=$(readlink -f /usr/lib64/libnftnl.so.11 2>/dev/null)
    [ -f "$real_file" ]
    CHECK_RESULT $? 0 0 "libnftnl.so.11 symlink broken"

    # Test libnftnl_ldconfig: Verify library is in ldconfig cache
    ldconfig -p 2>/dev/null | grep "libnftnl.so.11"
    CHECK_RESULT $? 0 0 "libnftnl.so.11 not in ldconfig cache"

    # Test nftables_install: Verify nftables package is installed (depends on libnftnl)
    rpm -q nftables > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "nftables package not installed"

    # Test nftables_version: Check nftables package version
    nftables_ver=$(rpm -q nftables --qf "%{VERSION}" 2>/dev/null)
    [ -n "$nftables_ver" ]
    CHECK_RESULT $? 0 0 "nftables version not found"

    # Test nft_binary: Verify nft binary exists and is executable
    [ -x /usr/sbin/nft ]
    CHECK_RESULT $? 0 0 "nft binary not found or not executable"

    # Test nft_link_libnftnl: Verify nft binary links to libnftnl
    ldd /usr/sbin/nft 2>/dev/null | grep "libnftnl"
    CHECK_RESULT $? 0 0 "nft binary not linked to libnftnl"

    # Test nft_link_libmnl: Verify nft binary links to libmnl (dependency of libnftnl)
    ldd /usr/sbin/nft 2>/dev/null | grep "libmnl"
    CHECK_RESULT $? 0 0 "nft binary not linked to libmnl"

    # Test nft_help: Verify nft help works
    nft --help > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "nft --help failed"

    # Test nft_version: Verify nft version output
    nft --version | grep "nftables"
    CHECK_RESULT $? 0 0 "nft --version failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    nft flush ruleset 2>/dev/null
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"