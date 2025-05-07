#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   @meitingli
#@Contact   	:   bubble_mt@outlook.com
#@Date      	:   2020-12-02
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test zip/unzip on same fs
#####################################

source "${OET_PATH}/testcases/system-test/fs-test/common_lib/fsio_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "lvm2 unzip"
    read -r -a point_list <<< "$(CREATE_FS "ext3 ext4 xfs")"
    for i in $(seq 1 $((${#point_list[@]} - 1))); do
        var=${point_list[$i]}
        mkdir -p "$var/testDir" "$var/testDir2" "$var/test1/test2/test3"
        echo "test file" >"$var/testDir/testFile"
        echo "test file1" >"$var/test1/testfile1"
        echo "test file2" >"$var/test1/test2/testfile2"
        echo "test file3" >"$var/test1/test2/test3/testfile3"
        echo "test homefile" >"$var/testfile"
    done
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    for i in $(seq 1 $((${#point_list[@]} - 1))); do
        var=${point_list[$i]}
        zip -r "$var/testdir.zip" "$var/testDir"
        CHECK_RESULT $? 0 0 "Compress file by zip in $var failed."
        unzip -l "$var/testdir.zip" | grep "testDir/testFile"
        CHECK_RESULT $? 0 0 "Check file on zip in $var failed."
        unzip "$var/testdir.zip"
        find "$var/testDir" -maxdepth 1 -name "*testFile*"
        CHECK_RESULT $? 0 0 "Decompress file by zip in $var failed."
        zip -r "$var/test.zip" "$var/test1"
        zip -d "$var/test.zip" "$var/test1/testfile1" |grep "deleting"
        CHECK_RESULT $? 0 0 "delete $var/test1/testfile1 failed in $var/test.zip"
        zip -m "$var/testfile" "$var/test.zip" |grep "adding"
        CHECK_RESULT $? 0 0 "add $var/testfile failed in $var/test.zip"
        zip -j "$var/test1.zip" "$var/test1"
        CHECK_RESULT $? 0 1 "-j does not support compressing directories"
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    list="${point_list[*]}"
    REMOVE_FS "$list"
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
