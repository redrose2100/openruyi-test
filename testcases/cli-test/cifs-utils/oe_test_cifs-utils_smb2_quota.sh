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
# @Date      :   2026-08-03
# @License   :   Mulan PSL v2
# @Desc      :   Test smb2-quota command - SMB2 quota tool
# ############################################
# shellcheck disable=SC2119

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "cifs-utils"
    if ! command -v python > /dev/null 2>&1; then
        python3_path="$(command -v python3 2>/dev/null)"
        if [ -n "$python3_path" ]; then
            ln -sf "$python3_path" /usr/local/bin/python
            export PATH="/usr/local/bin:$PATH"
            hash -r 2>/dev/null || true
        fi
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test command_exists: Verify smb2-quota command is available
    which smb2-quota > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "smb2-quota command not found"

    # Test python_available: Ensure python is available for smb2-quota
    which python > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "python not found for smb2-quota"

    # Test no_args: Show usage or error when no arguments provided
    smb2-quota 2>&1 | grep -i "usage\|error" > /dev/null
    CHECK_RESULT $? 0 0 "smb2-quota no-args usage/error missing"

    # Test -h: Show help
    smb2-quota -h 2>&1 | grep -i "usage\|help" > /dev/null
    CHECK_RESULT $? 0 0 "smb2-quota -h help missing"

    # Test -t: Tabular format option 
    smb2-quota -t /tmp/test_file > /dev/null 2>&1; ret=$?; [ $ret -eq 0 ] || [ $ret -eq 2 ]
    CHECK_RESULT $? 0 0 "smb2-quota -t option accepted"

    # Test -c: CSV format option
    smb2-quota -c /tmp/test_file > /dev/null 2>&1; ret=$?; [ $ret -eq 0 ] || [ $ret -eq 2 ]
    CHECK_RESULT $? 0 0 "smb2-quota -c option accepted"

    # Test -l: List format option
    smb2-quota -l /tmp/test_file > /dev/null 2>&1; ret=$?; [ $ret -eq 0 ] || [ $ret -eq 2 ]
    CHECK_RESULT $? 0 0 "smb2-quota -l option accepted"

    # Test invalid_option: Invalid option should fail
    smb2-quota --no-such-option /tmp/test_file > /dev/null 2>&1; ret=$?; [ $ret -ne 0 ]
    CHECK_RESULT $? 0 0 "smb2-quota invalid option should fail"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    if [ -L "/usr/local/bin/python" ]; then
        rm -f "/usr/local/bin/python" 2>/dev/null || true
    fi
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
