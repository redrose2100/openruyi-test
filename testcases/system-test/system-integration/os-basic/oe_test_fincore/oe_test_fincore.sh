#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wangmengke
# @Contact   :   wangmengke@uniontech.com
# @Date      :   2024-4-22
# @License   :   Mulan PSL v2
# @Desc      :   Fincore
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    echo "aabbcc" >/tmp/test.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    fincore /etc/passwd | grep -i /etc/passwd
    CHECK_RESULT $? 0 0 "fincore is failed!"
    fincore -J /tmp/test.txt |grep -i "{"
    CHECK_RESULT $? 0 0 "fincore function error"
    fincore -b /tmp/test.txt |grep -i 4096
    CHECK_RESULT $? 0 0 "fincore function error"
    fincore -n /tmp/test.txt |grep -i "4K     1   7B /tmp/test.txt"
    CHECK_RESULT $? 0 0 "fincore function error"
    fincore -r /tmp/test.txt |grep -i "4K 1 7B /tmp/test.txt"
    CHECK_RESULT $? 0 0 "fincore function error"
    fincore -V | grep -i 'fincore from util-linux'
    CHECK_RESULT $? 0 0 "fincore verison error"
    fincore -h | grep  -i 'help'
    CHECK_RESULT $? 0 0  "fincore help failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=${OLD_LANG}
    rm -rf /tmp/test.txt
    LOG_INFO "start environment cleanup!"
}

main "$@"
