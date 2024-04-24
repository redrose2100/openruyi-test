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
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    unxz -z testxz
    CHECK_RESULT $? 0 0 "Test failed with option -z"
    test -f testxz.xz
    CHECK_RESULT $? 0 0 "Compression failed"
    unxz -k -d testxz.xz
    CHECK_RESULT $? 0 0 "Test failed with option -d"
    test -f testxz
    CHECK_RESULT $? 0 0 "Decompression failed"
    unxz -t -vv testxz.xz 2>&1 | grep "/ 12 B ="
    CHECK_RESULT $? 0 0 "Test failed with option -t"
    unxz -l -vv testxz.xz | grep Stream
    CHECK_RESULT $? 0 0 "Test failed with option -l"
    rm -rf testxz && unxz -k testxz.xz
    CHECK_RESULT $? 0 0 "Test failed with option -k"
    test -f testxz.xz
    CHECK_RESULT $? 0 0 "File retention failed"
    unxz -k -f testxz.xz
    CHECK_RESULT $? 0 0 "Test failed with option -f"
    test -f testxz
    CHECK_RESULT $? 0 0 "File overwrite failed"
    unxz -k -f -c -d testxz.xz | grep "hello world"
    CHECK_RESULT $? 0 0 "Test failed with option -c"
    unxz -z -k -f -e -vv testxz 2>&1 | grep depth=512
    CHECK_RESULT $? 0 0 "Test failed with option -e"
    unxz -z -k -f -T 0 -vv textxz 2>&1 | grep nice=64
    CHECK_RESULT $? 0 0 "Test failed with option -T"
    unxz -z -k -f -q testxz.xz >testlog 2>&1
    CHECK_RESULT $? 0 1 "Test failed with option -q"
    test -s testlog
    CHECK_RESULT $? 0 1 "Test failed with option -q"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=${OLD_LANG}
    DNF_REMOVE "$@"
    rm -rf testxz testxz.xz testlog
    LOG_INFO "End to restore the test environment."
}

main "$@"
