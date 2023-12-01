#!/usr/bin/bash

# Copyright (c) 2021 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-10
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-mv
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    ls /tmp/test1 && rm -rf /tmp/test1
    ls /tmp/test2 && rm -rf /tmp/test2

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    mkdir test1
    mv test1 /tmp
    ls /tmp/test1
    CHECK_RESULT $? 0 0 "check mv test1 fail"

    mv /tmp/test1 /tmp/test2 && ls /tmp/test2
    CHECK_RESULT $? 0 0 "mv test1 to test2 fail"
    rm -rf /tmp/test2

    mkdir test2 && mv -f test2 /tmp
    ls /tmp/test2
    CHECK_RESULT $? 0 0 "check mv -f fail"

    mkdir /tmp/name1
    ls /tmp/name1
    CHECK_RESULT $? 0 0 "check dir name1 fail"
    mv /tmp/name1 /tmp/name2
    ls /tmp/name2
    CHECK_RESULT $? 0 0 "check dir name2 fail"
    ls /tmp/name1
    CHECK_RESULT $? 0 1 "check no name1 fail"

    mv /tmp/name2 /tmp/name3
    ls /tmp/name3
    CHECK_RESULT $? 0 0 "check dir name3 fail"
    ls /tmp/name2
    CHECK_RESULT $? 0 1 "check no name2 fail"

    mv /tmp/name3 /tmp/name1
    ls /tmp/name1
    CHECK_RESULT $? 0 0 "check dir name1 fail"
    ls /tmp/name3
    CHECK_RESULT $? 0 1 "check no name3 fail"

    mv --help 2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "check mv help fail"

    # /tmp/test1
    mkdir -p /tmp/test
    touch /tmp/test/testfile1
    echo 'test' > /tmp/test/testfile1
    inode1=$(stat /tmp/test/testfile1 | grep Inode | cut -d : -f 3 | awk '{print $1}')
    mv /tmp/test/testfile1 /tmp/test/testfile2
    inode3=$(stat /tmp/test/testfile2 | grep Inode | cut -d : -f 3 | awk '{print $1}')
    CHECK_RESULT "$inode1" "$inode3" 0 "Check inode failed."
    grep -q "test" /tmp/test/testfile2
    CHECK_RESULT $? 0 0 "The file info of /tmp/test/testfile2 is false."
    touch /tmp/test/testfile3
    echo "cover" >/tmp/test/testfile3
    grep -q "cover" /tmp/test/testfile3
    CHECK_RESULT $? 0 0 "The file info of /tmp/test/testfile3 is false."
    mv -f /tmp/test/testfile2 /tmp/test/testfile3
    grep -q "test" /tmp/test/testfile3
    CHECK_RESULT $? 0 0 "The file info of /tmp/test/testfile3 is false."
    touch /tmp/test/testfile4
    echo "new" >/tmp/test/testfile4
    grep -q "new" /tmp/test/testfile4
    CHECK_RESULT $? 0 0 "The file info of /tmp/test/testfile4 is false."
    mv -u /tmp/test/testfile3 /tmp/test/testfile4
    grep -q "new" /tmp/test/testfile4
    CHECK_RESULT $? 0 0 "The file info of /tmp/test/testfile4 is false."
    mv -fb /tmp/test/testfile3 /tmp/test/testfile4
    grep -q "new" /tmp/test/testfile4~
    CHECK_RESULT $? 0 0 "The file info of -fb /tmp/test/testfile4 is false."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf /tmp/test* /tmp/name*

    LOG_INFO "End to restore the test environment."
}

main "$@"
