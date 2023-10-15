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
    echo -e "hello world hello world" >testxz1
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    xzcmp -b testxz testxz1 | grep "differ: byte 12"
    CHECK_RESULT $? 0 0 "Test failed with option -b"
    xzcmp --ignore-initial=2 testxz testxz1 | grep "differ: byte 10"
    CHECK_RESULT $? 0 0 "Test failed with option --ignore-initial"
    xzcmp --ignore-initial=3:1 testxz testxz1 | grep "differ: byte 1"
    CHECK_RESULT $? 0 0 "Test failed with option --ignore-initial=3:1"
    xzcmp -l testxz testxz1 | grep "12  12  40"
    CHECK_RESULT $? 0 0 "Test failed with option -l"
    xzcmp -n3 testxz testxz1 >testlog 2>&1
    CHECK_RESULT $? 0 0 "Test failed with option -n3"
    test -s testlog
    CHECK_RESULT $? 0 1 "The first three bytes of two files are different"
    xzcmp -n13 testxz testxz1 | grep "differ: byte 12"
    CHECK_RESULT $? 0 0 "Test failed with option -n13"
    xzcmp -s testxz testxz1 >testlog 2>&1
    CHECK_RESULT $? 0 1 "Test failed with option -s"
    test -s testlog
    CHECK_RESULT $? 0 1 "The file is not empty"
    xzcmp --help | grep -i "Usage: xzcmp"
    CHECK_RESULT $? 0 0 "Test failed with option -b"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=${OLD_LANG}
    DNF_REMOVE "$@"
    rm -rf testxz testxz1 testlog
    LOG_INFO "End to restore the test environment."
}

main "$@"
