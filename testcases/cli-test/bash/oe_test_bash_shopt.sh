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
#@Desc          :   bash shopt shell behavior options (globstar, extglob, nullglob)
###################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    # 创建临时目录及嵌套文件
    tmpdir=$(mktemp -d) || { LOG_ERROR "mktemp tmpdir failed"; exit 1; }
    testdir2=""  # 初始化，防止 post_test 误删
    mkdir -p "$tmpdir/a/b/c"
    touch "$tmpdir/f1.txt" "$tmpdir/a/f2.txt" "$tmpdir/a/b/f3.txt" "$tmpdir/a/b/c/f4.txt"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."

    # ---------- globstar 测试 ----------
    bash -c "shopt -s globstar; cd \"$tmpdir\"; echo **/*.txt" > "$tmpdir/globstar_out.txt" 2>/dev/null
    CHECK_RESULT $? 0 0 "shopt globstar execution failed"
    grep -q "f1.txt" "$tmpdir/globstar_out.txt"
    CHECK_RESULT $? 0 0 "globstar should find root-level file f1.txt"
    grep -q "f4.txt" "$tmpdir/globstar_out.txt"
    CHECK_RESULT $? 0 0 "globstar should find deeply nested file f4.txt"

    # ---------- extglob 测试 ----------
    bash -c "shopt -s extglob; cd \"$tmpdir\"; ls f[0-9].txt" > "$tmpdir/extglob_out.txt" 2>/dev/null
    grep -q "f1.txt" "$tmpdir/extglob_out.txt"
    CHECK_RESULT $? 0 0 "extglob should match pattern f[0-9].txt"

    # ---------- nullglob 测试 ----------
    result=$(bash -c "shopt -s nullglob; echo nofile_*.zzz 2>/dev/null")
    test -z "$result"
    CHECK_RESULT $? 0 0 "nullglob should expand unmatched glob to empty"

    # ---------- failglob 测试 ----------
    bash -c 'shopt -s failglob; echo nofile_*.zzz' >/dev/null 2>&1
    CHECK_RESULT $? 0 1 "failglob should return non-zero on unmatched glob"

    # ---------- shopt -p 测试 ----------
    bash -c 'shopt -p' 2>&1 | grep -q "shopt"
    CHECK_RESULT $? 0 0 "shopt -p output missing shopt keyword"

    # ---------- shopt -q 测试（避免 A&&B||C） ----------
    result3=$(bash -c 'shopt -s extglob; if shopt -q extglob; then echo yes; else echo no; fi')
    test "$result3" = "yes"
    CHECK_RESULT $? 0 0 "shopt -q extglob should report set after enable"

    # ---------- dotglob 测试 ----------
    testdir2=$(mktemp -d) || { LOG_ERROR "mktemp testdir2 failed"; return 1; }
    touch "$testdir2/.hidden_file" "$testdir2/visible"
    bash -c "shopt -s dotglob; cd \"$testdir2\"; echo *" > "$tmpdir/dotglob_out.txt" 2>/dev/null
    grep -q ".hidden_file" "$tmpdir/dotglob_out.txt"
    CHECK_RESULT $? 0 0 "dotglob should include hidden files"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    # 清理临时目录（无 ntp 相关操作）
    [[ -n "$tmpdir" ]] && rm -rf "$tmpdir"
    [[ -n "$testdir2" ]] && rm -rf "$testdir2"
    LOG_INFO "End to restore the test environment."
}

main "$@"
