#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2023/07/11
# @License   :   Mulan PSL v2
# @Desc      :   The usage of commands in xz package
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL xz
    echo -e "hello world\nhello world" >testxz
    echo "hello world" >testxz1
    mkdir testdir testdir1
    cp testxz testdir
    echo "Hello World" >testxz2
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    xzdiff -r testdir testdir1 | grep "testdir"
    CHECK_RESULT $? 0 0 "Test failed with option -r"
    xzdiff -N -r testdir testdir1 | grep "1,2d0"
    CHECK_RESULT $? 0 0 "Test failed with option -N"
    xzdiff --unidirectional-new-file -r testdir testdir1 | grep "Only in testdir"
    CHECK_RESULT $? 0 0 "Test failed with option --unidirectional-new-file"
    echo "hello world" >testXZ
    cp testXZ testdir
    xzdiff -StestxZ testdir testdir1 | head -n 1 | grep -i testXZ
    CHECK_RESULT $? 0 0 "Test failed with option -S"
    xzdiff -i testxz1 testxz2 >testlog
    CHECK_RESULT $? 0 0 "Test failed with option -i"
    test -s testlog
    CHECK_RESULT $? 1 0 "The difference in case of file content is not ignored"
    echo "hello world " >testxz2
    xzdiff -Z testxz1 testxz2 >testlog
    CHECK_RESULT $? 0 0 "Test failed with option -Z"
    test -s testlog
    CHECK_RESULT $? 1 0 "Space at the end of each line not ignored"
    echo "hello world   " >testxz2
    xzdiff -b testxz1 testxz2 >testlog
    CHECK_RESULT $? 0 0 "Test failed with option -b"
    test -s testlog
    CHECK_RESULT $? 1 0 "Differences caused by different number of spaces not ignored"
    echo "hello     world   " >testxz2
    xzdiff -w testxz1 testxz2 >testlog
    CHECK_RESULT $? 0 0 "Test failed with option -w"
    test -s testlog
    CHECK_RESULT $? 1 0 "Not ignoring all spaces"
    xzdiff -D testxz1 testxz2 | grep "#ifndef"
    CHECK_RESULT $? 0 0 "Test failed with option -D"
    xzdiff --line-format=LFMT testxz1 testxz2 | grep LFMT
    CHECK_RESULT $? 0 0 "Test failed with option --line-format"
    xzdiff --help | grep -i "Usage: xzdiff"
    CHECK_RESULT $? 0 0 "Test failed with option --help"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=${OLD_LANG}
    DNF_REMOVE "$@"
    rm -rf ./test*
    LOG_INFO "End to restore the test environment."
}

main "$@"
