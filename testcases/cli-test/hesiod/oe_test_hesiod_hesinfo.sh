#!/usr/bin/bash

# Copyright (c) 2022. Lanzhou University of Technology.,Univ.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   DingYaoyao
# @Contact   :   d1005562341@126.com
# @Date      :   2022/09/29
# @License   :   Mulan PSL v2
# @Desc      :   Test hesinfo
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# Installation Preparation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "bind hesiod nss_hesiod"
    touch /etc/resolv.conf /etc/named.conf /etc/hesiod.conf
    # Comment the test information for subsequent deletion (# hesiod_test)
    sed '1a nameserver 127.0.0.1 # hesiod_test' /etc/resolv.conf > /etc/resolv.conf
    sed -i '$a zone "ns.test.com" { # hesiod_test\
    type master; # hesiod_test\
    file "named.hesiod"; # hesiod_test\
}; # hesiod_test' /etc/named.conf
    echo "rhs=.test.com
lhs=.ns
classes=HS,IN" > /etc/hesiod.conf
    # Load Test samples
    cp -f common/named.hesiod /var/named/
    systemctl restart named
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    hesinfo testuserABC grplist | grep "testuserABC:1000"
    CHECK_RESULT $? 0 0 "hesinfo output error"
    hesinfo -l 1000 uid | grep "resolves to"
    CHECK_RESULT $? 0 0 "option: -l error"
    hesinfo -b testuserABC group | grep "testuserABC.group.ns.test.com"
    CHECK_RESULT $? 0 0 "option: -b error"
    LOG_INFO "End to run test."
}

# Post processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /var/named/named.hesiod /etc/hesiod.conf
    sed -i '/hesiod_test/d' /etc/resolv.conf
    sed -i '/hesiod_test/d' /etc/named.conf
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"