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
# @Date      :   2026/07/13
# @License   :   Mulan PSL v2
# @Desc      :   Test nano command: file-operation options
# #############################################
# shellcheck disable=SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh
source "${OET_PATH}"/testcases/function-test/pkgs-test/nano/common/nano_common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "nano"
    mkdir -p /tmp/nano_test
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /tmp/nano_test || exit 1

    # Test -B: backup file — saving a modification creates <file>~ with original content
    echo "backup source" > backup.txt
    nano_write_save "-B" backup.txt "modified content"
    test -f backup.txt~
    CHECK_RESULT $? 0 0 "nano -B did not create backup file backup.txt~"
    grep "backup source" backup.txt~
    CHECK_RESULT $? 0 0 "backup file does not contain original content"

    # Test -v: view mode — open file read-only, content unchanged
    echo "view only content" > view.txt
    nano_open_exit "-v" view.txt
    grep "view only content" view.txt
    CHECK_RESULT $? 0 0 "view.txt content changed in view mode"

    # Test -c: constant cursor position display — file content unchanged
    echo "cursor test" > cursor.txt
    nano_open_exit "-c" cursor.txt
    grep "cursor test" cursor.txt
    CHECK_RESULT $? 0 0 "cursor.txt content changed after nano -c open"

    # Test -t: save on exit without prompting — content saved automatically
    echo "save on exit source" > saveexit.txt
    nano_write_save "-t" saveexit.txt
    grep "test line content" saveexit.txt
    CHECK_RESULT $? 0 0 "nano -t did not save content on exit"

    # Test -C: backup directory — combined with -B, backup placed in specified dir
    # -B backup fires when saving a modification to an existing file.
    # After saving, the backup directory should contain at least one backup file.
    mkdir -p backup_dir
    echo "backup dir source" > c_backup.txt
    expect <<EOF
        log_file /tmp/nano_test/log_c_backup
        set timeout 15
        spawn nano -B -C /tmp/nano_test/backup_dir c_backup.txt
        sleep 1
        send "modified content\r"
        sleep 1
        send "\017"
        sleep 1
        send "\r"
        sleep 2
        send "\030"
        sleep 2
        expect eof
EOF
    # Dynamically check backup_dir contains a backup file (name may vary by version)
    test -n "$(ls -A backup_dir/ 2>/dev/null)"
    CHECK_RESULT $? 0 0 "nano -C did not place backup in the specified directory"
    grep "backup dir source" backup_dir/*
    CHECK_RESULT $? 0 0 "backup file in directory does not contain original content"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/nano_test
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
