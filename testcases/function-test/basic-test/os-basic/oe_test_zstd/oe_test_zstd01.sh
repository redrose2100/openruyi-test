#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   fuyahong 
# @Contact   :   fuyahong@uniontech.com
# @Date      :   2024-07-19
# @License   :   Mulan PSL v2
# @Desc      :   function verification
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8 
    DNF_INSTALL zstd
    echo "aaa" >file1
    mkdir -p testdir;
    echo "bbb" >testdir/file2
    mkdir -p testdir/dir01;
    echo "ccc" >testdir/dir01/file3
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    zstd -3 -v file1
    zstd -l file1.zst
    CHECK_RESULT $? 0 0 "check -l option fail"
    
    zstd --rm -r testdir    
    test -e testdir/file2.zst
    CHECK_RESULT $? 0 0  "check file2.zst exist fail"
    test -e testdir/dir01/file3.zst
    CHECK_RESULT $? 0 0 "check file3.zst exist fail"
    test -e testdir/dir01/file3
    CHECK_RESULT $? 1 0 "check file3 exist fail"
    test -e testdir/file2
    CHECK_RESULT $? 1 0 "check file3 exist fail"
    zstd -d testdir/file2.zst
    test -e testdir/file2
    CHECK_RESULT $? 0 0 "check file2 exist fail after decompress"
    zstd -V 
    CHECK_RESULT $? 0 0 "check -V option fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    export LANG=${OLD_LANG}
    rm -rf file* testdir
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"



