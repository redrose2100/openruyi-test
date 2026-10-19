#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   maojiasheng
# @Contact   :   maojiasheng@uniontech.com
# @Date      :   2026-06-03
# @License   :   Mulan PSL v2
# @Desc      :   test realpath common options and path canonicalization
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    mkdir -p testdir/subdir
    touch testdir/subdir/testfile

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."

    # help
    realpath --help | grep -- "--relative-to"
    CHECK_RESULT $? 0 0 "realpath --help failed"

    # basic path resolution
    result=$(realpath testdir/subdir/testfile)
    [[ "$result" =~ /testdir/subdir/testfile$ ]]
    CHECK_RESULT $? 0 0 "basic realpath failed"

    # canonicalize path
    result=$(realpath testdir/subdir/../subdir/testfile)
    [[ "$result" =~ /testdir/subdir/testfile$ ]]
    CHECK_RESULT $? 0 0 "canonicalization failed"

    # -e : existing file
    realpath -e testdir/subdir/testfile >/dev/null
    CHECK_RESULT $? 0 0 "realpath -e existing file failed"

    # -e : non-existing file
    realpath -e testdir/not_exist >/dev/null 2>&1
    CHECK_RESULT $? 0 1 "realpath -e should fail for nonexistent path"

    # -m : allow missing path
    realpath -m testdir/not_exist >/dev/null
    CHECK_RESULT $? 0 0 "realpath -m failed"

    # relative path
    result=$(realpath --relative-to=testdir testdir/subdir/testfile)
    [ "$result" = "subdir/testfile" ]
    CHECK_RESULT $? 0 0 "realpath --relative-to failed"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf testdir

    LOG_INFO "End to restore the test environment."
}

main "$@"


