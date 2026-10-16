#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
###################################
#@Author        :   yangyuangan
#@Contact       :   yangyuangan@uniontech.com
#@Date          :   2026/5/20
#@License       :   Mulan PSL v2
#@Desc          :   bash printf formatted output for script reporting
###################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    tmpfile=$(mktemp)
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."

    # printf formatted table (simulating a status report)
    printf "%-15s %s\n" "SERVICE" "STATUS" > "$tmpfile"
    printf "%-15s %s\n" "sshd" "running" >> "$tmpfile"
    printf "%-15s %s\n" "cron" "stopped" >> "$tmpfile"
    CHECK_RESULT $? 0 0 "printf table formatting failed"
    grep -q "sshd.*running" "$tmpfile"
    CHECK_RESULT $? 0 0 "printf table content mismatch"

    # printf with width/precision for numeric alignment
    printf "%8s %8s\n" "PID" "MEM%" > "$tmpfile"
    printf "%8d %7.1f%%\n" 1234 2.3 >> "$tmpfile"
    CHECK_RESULT $? 0 0 "printf numeric formatting failed"
    grep -q "2.3%" "$tmpfile"
    CHECK_RESULT $? 0 0 "printf float precision mismatch"

    # printf %q shell-quotes a value
    val="file with spaces.txt"
    quoted=$(printf '%q' "$val")
    echo "$quoted" | grep -q "file\\\\ with\\\\ spaces"
    CHECK_RESULT $? 0 0 "printf %%q quoting failed"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f "$tmpfile"
    LOG_INFO "End to restore the test environment."
}

main "$@"
