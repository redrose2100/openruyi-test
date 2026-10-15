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
    xz testxz
    xz_version=$(rpm -qa xz | awk -F- '{print $2}')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    xzdec -d testxz.xz | grep "hello world"
    CHECK_RESULT $? 0 0 "Test failed with option -d"
    xzdec -k testxz.xz
    CHECK_RESULT $? 0 0 "Test failed with option -k"
    test -f testxz.xz
    CHECK_RESULT $? 0 0 "The file is not exsit"
    xzdec -c testxz.xz | grep "hello world"
    CHECK_RESULT $? 0 0 "Test failed with option -c"
    xzdec -qq testxz >testlog
    CHECK_RESULT $? 1 0 "Test failed with option -qq"
    test -s testlog
    CHECK_RESULT $? 0 1 "The file is not empty"
    xzdec -Q testxz.xz | grep -i warn
    CHECK_RESULT $? 0 1 "Test failed with option -Q"
    xzdec -h | grep -i "Usage: xzdec"
    CHECK_RESULT $? 0 0 "Test failed with option -h"
    xzdec -V | grep "${xz_version}"
    CHECK_RESULT $? 0 0 "Test failed with option -V"
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
