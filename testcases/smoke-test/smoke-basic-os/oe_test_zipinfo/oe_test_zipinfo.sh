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
# @Author    :   qinjiaxi
# @Contact   :   qinjiaxi@uniontech.com
# @Date      :   2024-08-22
# @License   :   Mulan PSL v2
# @Desc      :   test zipinfo
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    cd /tmp || exit
    echo "hello" > test.txt
    zip test.zip test.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    cd /tmp || exit
    zipinfo -1 test.zip | grep test.txt
    CHECK_RESULT $? 0 0 "zipinfo -l execute fail"
    zipinfo -2 -t test.zip | grep 1
    CHECK_RESULT $? 0 0 "zipinfo --help execute fail"
    zipinfo -h test.zip | grep test.zip
    CHECK_RESULT $? 0 0 "zipinfo --version execute fail"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test.txt
    rm -rf /tmp/test.zip
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
