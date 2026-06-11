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
#@Author        :   郑威
#@Contact       :   zhengwei@uniontech.com
#@Date          :   2026/5/11
#@License       :   Mulan PSL v2
#@Desc          :   bash trap signal handling and script cleanup
###################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    test_dir=$(mktemp -d) || { LOG_ERROR "mktemp test_dir failed"; exit 1; }
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."

    # trap EXIT runs cleanup on normal exit
    bash -c "
        trap 'echo cleaned_up > \"$test_dir/trap_exit_test.txt\"' EXIT
        echo running
    " >/dev/null 2>&1
    test -f "$test_dir/trap_exit_test.txt"
    CHECK_RESULT $? 0 0 "trap EXIT cleanup file not created"
    grep -q "cleaned_up" "$test_dir/trap_exit_test.txt"
    CHECK_RESULT $? 0 0 "trap EXIT cleanup content mismatch"

    # trap ERR catches command failures
    bash -c "
        set -e
        trap 'echo error_caught > \"$test_dir/trap_err_test.txt\"' ERR
        false
    " >/dev/null 2>&1
    test -f "$test_dir/trap_err_test.txt"
    CHECK_RESULT $? 0 0 "trap ERR file not created"
    grep -q "error_caught" "$test_dir/trap_err_test.txt"
    CHECK_RESULT $? 0 0 "trap ERR not triggered by false"

    # trap RETURN runs on function return / sourced script
    bash -c "
        f() {
            trap 'echo returned > \"$test_dir/trap_return_test.txt\"' RETURN
            echo in function
        }
        f
    " >/dev/null 2>&1
    grep -q "returned" "$test_dir/trap_return_test.txt"
    CHECK_RESULT $? 0 0 "trap RETURN not triggered"

    # trap -p lists current traps
    bash -c 'trap "echo x" EXIT; trap -p' 2>&1 | grep -q "trap --"
    CHECK_RESULT $? 0 0 "trap -p output missing trap keyword"

    # trap with empty action resets to default
    bash -c "
        trap 'echo ignored' USR1
        trap '' USR1
        trap -p USR1 2>&1
    " > "$test_dir/trap_reset_out.txt"
    ! grep -q "echo ignored" "$test_dir/trap_reset_out.txt"
    CHECK_RESULT $? 0 0 "trap reset should remove handler"

    # trap DEBUG for per-command execution
    bash -c "
        trap 'echo debug_fired > \"$test_dir/trap_debug_test.txt\"' DEBUG
        true
    " >/dev/null 2>&1
    test -f "$test_dir/trap_debug_test.txt"
    CHECK_RESULT $? 0 0 "trap DEBUG not fired"
    grep -q "debug_fired" "$test_dir/trap_debug_test.txt"
    CHECK_RESULT $? 0 0 "trap DEBUG content mismatch"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "$test_dir"
    LOG_INFO "End to restore the test environment."
}

main "$@"
