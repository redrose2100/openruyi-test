#!/usr/bin/bash

# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test fetch-crl
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "httpry wget"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    httpry -h | grep "Usage: httpry"
    CHECK_RESULT $? 0 0 "Check httpry -h failed"
    # test -b
    httpry -b tmp.txt -o log.file -d
    for((i=1;i<=3;i++)); do
        wget www.baidu.com
    done
    SLEEP_WAIT 5
    grep "baidu" tmp.txt
    CHECK_RESULT $? 0 0 "Check httpry -b failed"
    pkill -9 -f "httpry -b"
    rm -f index* tmp.txt log.file
    httpry -i "${NODE1_NIC}" -b tmp.txt -o log.file -d
    for((i=1;i<=3;i++)); do
        wget www.baidu.com
    done
    SLEEP_WAIT 5
    grep "baidu" tmp.txt
    CHECK_RESULT $? 0 0 "Check httpry -i failed"
    pkill -9 -f "httpry -i"
    rm -f index* tmp.txt log.file
    httpry -i "${NODE1_NIC}" -b tmp.txt -o log.file -d
    wget www.baidu.com
    wget www.baidu.com
    SLEEP_WAIT 5
    httpry -r tmp.txt | grep "baidu"
    CHECK_RESULT $? 0 0 "Check httpry -r failed"
    pkill -9 -f "httpry -i"
    rm -f index* tmp.txt log.file
    httpry -o output.txt -d
    test -f output.txt
    CHECK_RESULT $? 0 0 "Check httpry -o failed"
    pkill -9 -f "httpry -o"
    rm -f index* output.txt
    httpry -i "${NODE1_NIC}" -m get -b tmp.txt -o log.file -d
    for((i=1;i<=3;i++)); do
        wget www.baidu.com
    done
    SLEEP_WAIT 5
    grep "baidu" tmp.txt
    CHECK_RESULT $? 0 0 "Check httpry -m failed"
    pkill -9 -f "httpry -i"
    rm -f index* tmp.txt log.file
    httpry -o output.txt -d
    test -f /run/httpry.pid
    CHECK_RESULT $? 0 0 "Check httpry -d failed"
    pkill -9 -f "httpry -o"
    rm -f index* output.txt
    httpry -n 2 -t 2 -b tmp.txt -o log.file -d
    for((i=1;i<=3;i++)); do
        wget www.baidu.com
    done
    SLEEP_WAIT 2
    grep "baidu" tmp.txt
    CHECK_RESULT $? 0 0 "Check httpry -t failed"
    pkill -9 -f "httpry -n"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f /run/httpry.pid index* tmp.txt log.file
    LOG_INFO "End to restore the test environment."
}

main "$@"
