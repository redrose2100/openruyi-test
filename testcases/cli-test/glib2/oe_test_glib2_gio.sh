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
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/08/04
# @License   :   Mulan PSL v2
# @Desc      :   test gio command
# ############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL glib2
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    mkdir -p /tmp/gio_test_dir
    echo "test content for gio" > /tmp/gio_test_dir/test_file.txt
    echo "another content" > /tmp/gio_test_dir/another_file.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    gio help 2>&1 | grep -i "Usage"
    CHECK_RESULT $? 0 0 "gio help check failed"
    # Test gio version
    gio version | grep "$(rpm -q glib2 | awk -F '-' '{print $2}')"
    CHECK_RESULT $? 0 0 "gio version check failed"
    
    # Test gio info
    gio info /tmp/gio_test_dir/test_file.txt 2>&1 | grep -i "display name"
    CHECK_RESULT $? 0 0 "gio info check failed"
    
    # Test gio cat
    gio cat /tmp/gio_test_dir/test_file.txt 2>&1 | grep "test content for gio"
    CHECK_RESULT $? 0 0 "gio cat check failed"
    
    # Test gio list
    gio list /tmp/gio_test_dir 2>&1 | grep -i "test_file.txt"
    CHECK_RESULT $? 0 0 "gio list check failed"
    
    # Test gio mkdir
    gio mkdir /tmp/gio_test_dir/subdir 2>&1
    CHECK_RESULT $? 0 0 "gio mkdir check failed"
    test -d /tmp/gio_test_dir/subdir
    CHECK_RESULT $? 0 0 "gio mkdir directory creation check failed"
    
    # Test gio copy
    gio copy /tmp/gio_test_dir/test_file.txt /tmp/gio_test_dir/test_copy.txt 2>&1
    CHECK_RESULT $? 0 0 "gio copy check failed"
    test -f /tmp/gio_test_dir/test_copy.txt
    CHECK_RESULT $? 0 0 "gio copy file creation check failed"
    
    # Test gio move
    gio move /tmp/gio_test_dir/test_copy.txt /tmp/gio_test_dir/test_moved.txt 2>&1
    CHECK_RESULT $? 0 0 "gio move check failed"
    test -f /tmp/gio_test_dir/test_moved.txt
    CHECK_RESULT $? 0 0 "gio move file check failed"
    test ! -f /tmp/gio_test_dir/test_copy.txt
    CHECK_RESULT $? 0 0 "gio move source removal check failed"
    
    # Test gio rename
    gio rename /tmp/gio_test_dir/test_moved.txt test_renamed.txt 2>&1
    CHECK_RESULT $? 0 0 "gio rename check failed"
    test -f /tmp/gio_test_dir/test_renamed.txt
    CHECK_RESULT $? 0 0 "gio rename file check failed"
    
    # Test gio tree
    gio tree /tmp/gio_test_dir 2>&1 | grep -i "test_file.txt"
    CHECK_RESULT $? 0 0 "gio tree check failed"
    
    # Test gio remove
    gio remove /tmp/gio_test_dir/test_renamed.txt 2>&1
    CHECK_RESULT $? 0 0 "gio remove check failed"
    test ! -f /tmp/gio_test_dir/test_renamed.txt
    CHECK_RESULT $? 0 0 "gio remove file deletion check failed"
    
    # Test gio save
    echo "saved content" | gio save /tmp/gio_test_dir/test_saved.txt 2>&1
    CHECK_RESULT $? 0 0 "gio save check failed"
    gio cat /tmp/gio_test_dir/test_saved.txt 2>&1 | grep "saved content"
    CHECK_RESULT $? 0 0 "gio save content check failed"
    
    # Test gio mime
    gio mime text/plain 2>&1
    CHECK_RESULT $? 0 0 "gio mime check failed"
    
    # Test gio monitor (will timeout)
    timeout 2 gio monitor /tmp/gio_test_dir 2>&1
    CHECK_RESULT $? 124 0 "gio monitor check failed (expected timeout)"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf /tmp/gio_test_dir
    export LANG=$OLD_LANG
    LOG_INFO "End to restore the test environment."
}

main "$@"
