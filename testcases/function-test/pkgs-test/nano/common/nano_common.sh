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
# @Desc      :   Common helpers for nano test cases.
# #############################################

# Open nano with given options, write text, save and exit.
# Usage: nano_write_save <options> <filename> [text]
#   options  - nano command-line options (pass "" for none)
#   filename - file to open
#   text     - line(s) to write before saving (default: "test line content")
function nano_write_save() {
    local options=$1
    local filename=$2
    local text=${3:-test line content}
    expect <<EOF
        log_file /tmp/nano_test/log_${filename}
        set timeout 15
        spawn nano ${options} ${filename}
        sleep 1
        send "${text}\r"
        sleep 1
        send "\017"
        sleep 1
        send "\r"
        sleep 1
        send "\030"
        sleep 1
        expect eof
EOF
}

# Open nano with given options and exit immediately without saving.
# Usage: nano_open_exit <options> <filename>
function nano_open_exit() {
    local options=$1
    local filename=$2
    expect <<EOF
        log_file /tmp/nano_test/log_${filename}
        set timeout 15
        spawn nano ${options} ${filename}
        sleep 1
        send "\030"
        sleep 1
        expect eof
EOF
}

