#!/usr/bin/bash

# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   cherry530
# @Contact   :   707078654@qq.com
# @Date      :   2026/07/09
# @License   :   Mulan PSL v2
# @Desc      :   Test nano command: editing-behavior options
# #############################################
# shellcheck disable=SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh
source "${OET_PATH}"/testcases/cli-test/nano/common/nano_common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "nano"
    mkdir -p /tmp/nano_test
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /tmp/nano_test || exit 1

    # Test -A: smart home key, verify nano starts and saves normally
    nano_write_save "-A" smarthome.txt
    grep "test line content" smarthome.txt
    CHECK_RESULT $? 0 0 "nano -A failed to save content"

    # Test -E: convert typed tabs to spaces
    expect <<EOF
        log_file /tmp/nano_test/log_tabstospaces
        set timeout 15
        spawn nano -E tabstospaces.txt
        sleep 1
        send "\t"
        sleep 1
        send "tabbed text\r"
        sleep 1
        send "\017"
        sleep 1
        send "\r"
        sleep 1
        send "\030"
        sleep 1
        expect eof
EOF
    grep "    tabbed text" tabstospaces.txt
    CHECK_RESULT $? 0 0 "nano -E did not convert tabs to spaces"

    # Test -i: auto-indent, both lines saved
    nano_write_save "-i" autoindent.txt "first line\rsecond line"
    grep "first line" autoindent.txt
    CHECK_RESULT $? 0 0 "nano -i missing first line"

    # Test -L: do not add newlines to ends of files
    nano_write_save "-L" nonewlines.txt
    test -f nonewlines.txt
    CHECK_RESULT $? 0 0 "nano -L failed to create file"

    # Test -N: no conversion of DOS format, verify nano saves normally
    expect <<EOF
        log_file /tmp/nano_test/log_noconvert
        set timeout 15
        spawn nano -N noconvert.txt
        sleep 1
        send "\t"
        sleep 1
        send "tabbed text\r"
        sleep 1
        send "\017"
        sleep 1
        send "\r"
        sleep 1
        send "\030"
        sleep 1
        expect eof
EOF
    grep "tabbed text" noconvert.txt
    CHECK_RESULT $? 0 0 "nano -N did not save tabbed content"

    # Test -R: restricted mode, verify nano starts and saves normally
    nano_write_save "-R" restricted.txt
    grep "test line content" restricted.txt
    CHECK_RESULT $? 0 0 "nano -R failed to save content in restricted mode"

    # Test -S: soft wrapping, verify nano starts and saves normally
    nano_write_save "-S" softwrap.txt
    grep "test line content" softwrap.txt
    CHECK_RESULT $? 0 0 "nano -S failed to save content"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/nano_test
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
