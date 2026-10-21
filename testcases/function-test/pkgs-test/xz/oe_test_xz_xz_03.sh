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
    echo "hello world" >testxz
    echo "hello world" >testxz1
    echo -e "testxz\ntestxz1" >testfile
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    xz -k -f -vv -S .SUF testxz
    CHECK_RESULT $? 0 0 "Test failed with option -S"
    test -f testxz.SUF
    CHECK_RESULT $? 0 0 "testxz.SUF does not exist"
    xz -k -f -vv --files=testfile 2>&1 | grep -A 10 testxz | grep testxz1
    CHECK_RESULT $? 0 0 "Test failed with option --file"
    xz -k -f -vv -F lzma testxz
    CHECK_RESULT $? 0 0 "Test failed with option -F"
    test -f testxz.lzma
    CHECK_RESULT $? 0 0 "testxz.lzma does not exist"
    xz -k -f -vv -C crc32 testxz
    CHECK_RESULT $? 0 0 "Test failed with option -C"
    xz -l testxz.xz | grep CRC32
    CHECK_RESULT $? 0 0 "Test failed with option -l"
    xz -k -f -vv --block-size=1 testxz 2>&1 | grep "392 B / 12 B > 9.999"
    CHECK_RESULT $? 0 0 "Test failed with option --block-size"
    xz -k -f -vv --block-list=1,2,128 testxz 2>&1 | grep "/ 12 B > 9.999"
    CHECK_RESULT $? 0 0 "Test failed with option --block-list"
    xz -k -f -vv --memlimit-compress=1 testxz 2>&1 | grep "The limit is 1 B"
    CHECK_RESULT $? 0 0 "Test failed with option --memlimit-compress"
    xz -k -f -vv -d --memlimit-decompress=2 testxz.xz 2>&1 | grep "The limit is 2 B"
    CHECK_RESULT $? 0 0 "Test failed with option --memlimit-decompress"
    xz -k -f -vv -F lzma --lzma1=dict=7MiB,lc=1,lp=1,pb=3,mode=normal,nice=128,mf=bt3,depth=1 testxz 2>&1 | grep "lzma1=dict=7MiB,lc=1,lp=1,pb=3,mode=normal,nice=128,mf=bt3,depth=1"
    CHECK_RESULT $? 0 0 "Test failed with option --lzma1"
    xz -k -f -vv --lzma2=dict=6MiB,lc=2,lp=2,pb=4,mode=fast,nice=256,mf=bt2,depth=2 testxz 2>&1 | grep "lzma2=dict=6MiB,lc=2,lp=2,pb=4,mode=fast,nice=256,mf=bt2,depth=2"
    CHECK_RESULT $? 0 0 "Test failed with option --lzma2"
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
