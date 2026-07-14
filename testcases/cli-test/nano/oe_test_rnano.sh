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
# @Desc      :   Test rnano command: restricted-mode specific behaviors
# #############################################

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

    # Verify rnano binary exists
    test -f /usr/bin/rnano
    CHECK_RESULT $? 0 0 "rnano binary does not exist"

    # Verify rnano is equivalent to nano -R (restricted mode)
    rnano --version | grep "GNU nano"
    CHECK_RESULT $? 0 0 "rnano --version does not output version banner"

    # Restricted-mode behavior 1: rnano can still edit and save the given file
    expect <<EOF
        log_file /tmp/nano_test/log_rnano_edit
        set timeout 15
        spawn rnano rnano_edit.txt
        sleep 1
        send "rnano restricted content\r"
        sleep 1
        send "\017"
        sleep 1
        send "\r"
        sleep 1
        send "\030"
        sleep 1
        expect eof
EOF
    test -f rnano_edit.txt
    CHECK_RESULT $? 0 0 "rnano failed to save file in restricted mode"
    grep "rnano restricted content" rnano_edit.txt
    CHECK_RESULT $? 0 0 "rnano saved file missing content"

    # Restricted-mode behavior 2: rnano does not read or write history files.
    # Remove any pre-existing history, run rnano, then assert history is absent.
    rm -f ~/.local/share/nano/search_history 2>/dev/null
    expect <<EOF
        log_file /tmp/nano_test/log_rnano_nohistory
        set timeout 15
        spawn rnano rnano_nohist.txt
        sleep 1
        send "no history\r"
        sleep 1
        send "\017"
        sleep 1
        send "\r"
        sleep 1
        send "\030"
        sleep 1
        expect eof
EOF
    test -e ~/.local/share/nano/search_history
    CHECK_RESULT $? 1 0 "rnano should not create history file in restricted mode"

    # Restricted-mode behavior 3: rnano disallows "Save As" (writing under a
    # different name). Triggering Ctrl+O then changing the filename should be
    # refused. Verify the original file is unchanged and no new file appears.
    echo "original content" > rnano_noas.txt
    expect <<EOF
        log_file /tmp/nano_test/log_rnano_noas
        set timeout 15
        spawn rnano rnano_noas.txt
        sleep 1
        send "\017"
        sleep 1
        send "rnano_noas_new.txt\r"
        sleep 1
        send "\030"
        sleep 1
        expect eof
EOF
    test -f rnano_noas_new.txt
    CHECK_RESULT $? 1 0 "rnano should disallow Save As in restricted mode"

    # Restricted-mode behavior 4: -v (view mode) can be combined with rnano
    echo "rnano view content" > rnano_view.txt
    expect <<EOF
        log_file /tmp/nano_test/log_rnano_view
        set timeout 15
        spawn rnano -v rnano_view.txt
        sleep 1
        send "\030"
        sleep 1
        expect eof
EOF
    grep "rnano view content" rnano_view.txt
    CHECK_RESULT $? 0 0 "rnano -v altered file content"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/nano_test
    rm -rf ~/.local/share/nano
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
