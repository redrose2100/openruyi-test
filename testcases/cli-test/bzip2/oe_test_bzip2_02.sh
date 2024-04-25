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
# @Author    :   zhaozhenyang
# @Contact   :   zhaozhenyang@uniontech.com
# @Date      :   2024-04-02
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
    cd /tmp  || exit
    touch testfile
    CHECK_RESULT $? 0 0 "compress fail"
    bzip2 --compress testfile
    test -e /tmp/testfile.bz2
    CHECK_RESULT $? 0 0 "bzip2 --compress command execution failure"
    bzip2 -L 
    CHECK_RESULT $? 0 0 "bzip2 -L command execution failure"
    bzip2 -d testfile.bz2
    bzip2 -s testfile 
    test -e testfile.bz2
    CHECK_RESULT $? 0 0 "bzip2 -s command execution failur"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    export LANG=${OLD_LANG}
    rm -rf /tmp/testfile.bz2
    DNF_REMOVE "$@"
    LOG_INFO "End to clean the test environment."
}

main "$@"
