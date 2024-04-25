#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xuyanyan
# @Contact   :   xuyanyan@uniontech.com
# @Date      :   2024-03-18
# @License   :   Mulan PSL v2
# @Desc      :   test find
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    mkdir -p /tmp/find_test/
    touch /tmp/find_test/two.txt
    touch /tmp/find_test/file.txt
    dd if=/dev/zero of=/tmp/find_test/file.txt bs=10k count=2
    mkdir -p /tmp/find_test/test
    touch /tmp/find_test/test/other_file.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    find  /tmp/find_test  -type f|grep 'other'
    CHECK_RESULT $? 0 0 "find fail"
    find  /tmp/find_test  -perm -644|grep 'other'
    CHECK_RESULT $? 0 0 "find fail"
    find  /tmp/find_test  -size 20k|grep 'file.txt'
    CHECK_RESULT $? 0 0 "find fail"
    find  /tmp/find_test  -maxdepth 1 -name '*txt' -a -name 'file*'|grep 'file.txt'
    CHECK_RESULT $? 0 0 "find fail"
    find  /tmp/find_test -maxdepth 1 -type f -mtime -1|grep 'two.txt'
    CHECK_RESULT $? 0 0 "find fail"
    find  /tmp/find_test -maxdepth 1 -type f -mtime +1|grep 'two.txt'
    CHECK_RESULT $? 1 0 "find fail"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/find_test/
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
