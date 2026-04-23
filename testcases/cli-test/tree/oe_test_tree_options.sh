#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   sjxjx
# @Contact   :   3541335833@qq.com
# @Date      :   2026-04-22
# @License   :   Mulan PSL v2
# @Desc      :   tree command test - additional options
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    mkdir -p /tmp/test/tree_opts
    path=/tmp/test/tree_opts
    mkdir -p ${path}/dir1/subdir1 ${path}/dir2/subdir2
    mkdir -p ${path}/dir3/hidden
    touch ${path}/file1.txt
    touch ${path}/file2.txt
    touch ${path}/dir1/file3.txt
    touch ${path}/dir1/subdir1/file4.txt
    touch -d "2024-01-01" ${path}/dir2/oldfile.txt
    touch -d "2025-01-01" ${path}/dir3/newfile.txt
    echo "test content" > ${path}/file1.txt
    DNF_INSTALL "tree"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."

    # Test 1: tree -a (show all files including hidden)
    LOG_INFO "Test 1: tree -a shows hidden files"
    tree -a ${path} | grep -q "\."
    CHECK_RESULT $? 0 0 "tree -a failed"

    # Test 2: tree -L (limit directory depth)
    LOG_INFO "Test 2: tree -L limits depth"
    tree -L 1 ${path} | grep -q "dir1"
    CHECK_RESULT $? 0 0 "tree -L 1 failed"
    tree -L 2 ${path} | grep -q "subdir1"
    CHECK_RESULT $? 0 0 "tree -L 2 failed"

    # Test 3: tree -s (print size)
    LOG_INFO "Test 3: tree -s prints size"
    tree -s ${path} | grep -q "[0-9]"
    CHECK_RESULT $? 0 0 "tree -s failed"

    # Test 4: tree -p (print permissions)
    LOG_INFO "Test 4: tree -p prints permissions"
    tree -p ${path} | grep -q "drwx"
    CHECK_RESULT $? 0 0 "tree -p failed"

    # Test 5: tree -h (print human readable size)
    LOG_INFO "Test 5: tree -h prints human readable size"
    tree -h ${path} 2>&1 | grep -qE "[0-9KMG]|human"
    CHECK_RESULT $? 0 0 "tree -h failed"

    # Test 6: tree -t (sort by modification time)
    LOG_INFO "Test 6: tree -t sorts by modification time"
    tree -t ${path} > /tmp/tree_t.txt
    CHECK_RESULT $? 0 0 "tree -t failed"

    # Test 7: tree -I (exclude pattern)
    LOG_INFO "Test 7: tree -I excludes pattern"
    tree -I "dir1|dir2" ${path} | grep -qv "dir1"
    CHECK_RESULT $? 0 0 "tree -I failed"

    # Test 8: tree --prune (prune empty directories)
    LOG_INFO "Test 8: tree --prune prunes empty directories"
    mkdir -p ${path}/empty_dir
    tree --prune ${path} 2>&1 | grep -qv "empty"
    CHECK_RESULT $? 0 0 "tree --prune failed"

    # Test 9: tree -u (print username)
    LOG_INFO "Test 9: tree -u prints username"
    tree -u ${path} | grep -q "root"
    CHECK_RESULT $? 0 0 "tree -u failed"

    # Test 10: tree -g (print group name)
    LOG_INFO "Test 10: tree -g prints group name"
    tree -g ${path} | grep -q "root"
    CHECK_RESULT $? 0 0 "tree -g failed"

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    rm -rf /tmp/test
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
