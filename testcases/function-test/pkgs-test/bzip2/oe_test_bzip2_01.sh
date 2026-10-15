#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   gaomingyang
# @Contact   :   gaomingyang@uniontech.com
# @Date      :   2024-04-01
# @License   :   Mulan PSL v2
# @Desc      :   test bzip2
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL bzip2
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    cd /tmp || exit 
    touch testfile
    CHECK_RESULT $? 0 0 "compress fail"
    bzip2 -z testfile
    test -e /tmp/testfile.bz2
    CHECK_RESULT $? 0 0 "bzip2 -z command execution failure"
    bzip2 -d testfile.bz2
    test -e /tmp/testfile
    CHECK_RESULT $? 0 0 "bzip2 -d command execution failure"
    bzip2 --stdout testfile > testfile1.bz2
    test -e testfile1.bz2
    CHECK_RESULT $? 0 0 "bzip2 --stdout command execution failur"
    bzip2 -c testfile > compressed_testfile.bz2
    CHECK_RESULT $? 0 0 "bzip2 -c command execution failure"
    test -e compressed_testfile.bz2
    CHECK_RESULT $? 0 0 "ls fail"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    export LANG=${OLD_LANG}
    rm -rf /tmp/testfile
    rm -rf /tmp/testfile.bz2
    rm -rf /tmp/testfile1.bz2
    rm -rf /tmp/compressed_testfile.bz2
    DNF_REMOVE "$@"
    LOG_INFO "End to clean the test environment."
}

main "$@"
