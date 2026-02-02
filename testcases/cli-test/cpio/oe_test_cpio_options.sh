#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   caowenqian
#@Contact   	:   caowenqi@uniontech.com
#@Date      	:   2026-02-02
#@License   	:   Mulan PSL v2
#@Desc      	:   command test-cpio options
#####################################


source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL cpio

    mkdir -p testdir/subdir
    echo "test file 1" > testdir/file1
    echo "test file 2" > testdir/file2
    echo "test file 3" > testdir/subdir/file3
    find testdir -type f > filelist

    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    LOG_INFO "test cpio -v option"
    cpio -ov < filelist > cpio_verbose.out 2>cpio_verbose.log
    CHECK_RESULT $? 0 0 "failed to cpio create with -v option..."
    grep -E "testdir/(file1|file2|subdir/file3)" cpio_verbose.log
    CHECK_RESULT $? 0 0 "failed to display verbose output with -v option..."

    LOG_INFO "test cpio -d option"
    rm -rf testdir
    cpio -id < cpio_verbose.out
    CHECK_RESULT $? 0 0 "failed to cpio extract with -d option..."
    test -d testdir/subdir
    CHECK_RESULT $? 0 0 "failed to create directory with -d option..."

    LOG_INFO "test cpio -m option"
    touch_time=$(stat -c %Y testdir/file1)
    sleep 1
    find testdir -type f > filelist_mtime
    cpio -o < filelist_mtime > cpio_mtime.out
    CHECK_RESULT $? 0 0 "failed to cpio create archive for -m test..."
    rm -rf testdir
    mkdir -p testdir
    cpio -imd < cpio_mtime.out
    CHECK_RESULT $? 0 0 "failed to cpio extract with -m option..."
    new_touch_time=$(stat -c %Y testdir/file1)
    CHECK_RESULT $((touch_time == new_touch_time)) 1 0 "failed to preserve modification time with -m option..."

    LOG_INFO "test cpio -a option"
    find testdir -type f > filelist_atime
    access_time_before=$(stat -c %X testdir/file1)
    sleep 1
    cpio -oa < filelist_atime > cpio_atime.out
    CHECK_RESULT $? 0 0 "failed to cpio create with -a option..."
    access_time_after=$(stat -c %X testdir/file1)
    CHECK_RESULT $((access_time_before == access_time_after)) 1 0 "failed to reset access time with -a option..."

    LOG_INFO "test cpio -L option"
    ln -sf file1 testdir/symlink1
    find testdir -type f -o -type l > filelist_symlink
    cpio -oL < filelist_symlink > cpio_deref.out
    CHECK_RESULT $? 0 0 "failed to cpio create with -L option..."
    rm -rf testdir
    cpio -id < cpio_deref.out
    CHECK_RESULT $? 0 0 "failed to cpio extract after -L option..."
    test -f testdir/symlink1 && ! test -L testdir/symlink1
    CHECK_RESULT $? 0 0 "failed to dereference symlink with -L option..."

    LOG_INFO "test cpio -n option"
    find testdir -type f > filelist_n
    cpio -o < filelist_n > cpio_numeric.out
    CHECK_RESULT $? 0 0 "failed to cpio create archive for -n test..."
    cpio -t < cpio_numeric.out > filelist_numeric
    CHECK_RESULT $? 0 0 "failed to cpio list archive..."
    cpio -tn < cpio_numeric.out > filelist_numeric_uid
    CHECK_RESULT $? 0 0 "failed to cpio list with -n option..."
    test -s filelist_numeric_uid
    CHECK_RESULT $? 0 0 "failed to generate output with -n option..."
    grep -q "[0-9]" filelist_numeric_uid
    CHECK_RESULT $? 0 0 "failed to display numeric UID/GID with -n option..."

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf cpio_verbose.out cpio_verbose.log cpio_mtime.out cpio_atime.out cpio_deref.out cpio_numeric.out filelist filelist_mtime filelist_atime filelist_link filelist_symlink filelist_n filelist_numeric filelist_numeric_uid testdir
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
