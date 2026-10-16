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
# @Author    :   chenjiamei
# @Contact   :   chenjiamei@uniontech.com
# @Date      :   2024-05-14
# @License   :   Mulan PSL v2
# @Desc      :   test echo
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    ls hello.txt && rm -rf hello.txt
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    echo "test" | grep "test"
    CHECK_RESULT $? 0 0 "echo execute fail"
    echo "hello" > hello.txt
    grep "hello" hello.txt
    CHECK_RESULT $? 0 0 "echo execute fail"
    echo "hello" > hello.txt
    echo "hello world" >>hello.txt
    count=$(grep -o "hello" hello.txt | wc -l) && [ "$count" -eq 2 ]
    CHECK_RESULT $? 0 0 "echo execute fail"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf hello.txt
    LOG_INFO "Finish environment cleanup!"
}

main "$@"