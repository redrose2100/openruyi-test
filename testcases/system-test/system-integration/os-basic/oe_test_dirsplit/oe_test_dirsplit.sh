#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2024/02/04
# @License   :   Mulan PSL v2
# @Desc      :   Basic functional verification of dirsplit
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "reiserfs-utils dirsplit"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    mkdir /tmp/test_dir && cd /tmp/test_dir || exit
    dd if=/dev/zero of=/tmp/test_dir/file.txt bs=1M count=10
    test -f file.txt
    CHECK_RESULT $? 0 0 "File generation failed"
    dirsplit -m -s 15M -e2 /tmp/test_dir/
    test -d vol_1
    CHECK_RESULT $? 0 0 "generation failed"
    dirsplit -v vol_1
    test -f vol_1.list
    CHECK_RESULT $? 0 0 "File generation failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/test_dir
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
