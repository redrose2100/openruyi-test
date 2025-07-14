#!/usr/bin/bash

# Copyright (c) 2022. huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2022/08/30
# @License   :   Mulan PSL v2
# @Desc      :   Test fetch-crl
# #############################################
# shellcheck disable=SC2009

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "httpry wget"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    httpry -i "${NODE1_NIC}" -f timestamp,source-ip,dest-ip,direction,host,request-uri,user-agent -o tmp.log -b tmp.txt -d
    for((i=1;i<=3;i++)); do
        curl www.baidu.com
    done
    SLEEP_WAIT 5
    httpry -r tmp.txt | grep "baidu"
    CHECK_RESULT $? 0 0 "Check httpry -f failed"
    pkill -9 -f "httpry -i"
    rm -f index* tmp.log tmp.txt
    # test -F
    httpry -i "${NODE1_NIC}" -b tmp.txt -o tmp.log -F -d
    for((i=1;i<=3;i++)); do
        curl www.baidu.com
    done
    SLEEP_WAIT 10
    grep "baidu" tmp.txt
    CHECK_RESULT $? 0 0 "Check httpry -F failed"
    pkill -9 -f "httpry -i"
    rm -f index* tmp.txt tmp.log
    # test -n
    httpry -i "${NODE1_NIC}" -b tmp.txt -n 3 -o tmp.log -d
    for((i=1;i<=4;i++)); do
        curl www.baidu.com
    done
    SLEEP_WAIT 5
    grep "baidu" tmp.txt
    CHECK_RESULT $? 0 0 "Check httpry -n failed"
    pkill -9 -f "httpry -i"
    rm -f index* tmp.txt tmp.log
    # test -p
    httpry -n 2 -p -o tmp.log -b tmp.txt -d
    for((i=1;i<=3;i++)); do
        curl www.baidu.com
    done
    SLEEP_WAIT 2
    grep "baidu" tmp.txt
    CHECK_RESULT $? 0 0 "Check httpry -p failed"
    pkill -9 -f "httpry -n"
    rm -f index* tmp.txt tmp.log
    # test -q
    httpry -i "${NODE1_NIC}" -n 2 -q -d -o /tmp/a.out
    CHECK_RESULT $? 0 0 "Check httpry -q failed"
    pkill -9 -f "httpry -i"
    # test -s
    httpry -n 2 -s -o tmp.log -b tmp.txt -d
    for((i=1;i<=3;i++)); do
        curl www.baidu.com
    done
    SLEEP_WAIT 2
    grep "baidu" tmp.txt
    CHECK_RESULT $? 0 0 "Check httpry -s failed"
    pkill -9 -f "httpry -n"
    rm -f index* tmp.txt tmp.log
    # test -l
    httpry -s -l 20 -o tmp.log -b tmp.txt -d
    for((i=1;i<=3;i++)); do
        curl www.baidu.com
    done
    SLEEP_WAIT 15
    grep "baidu" tmp.txt
    CHECK_RESULT $? 0 0 "Check httpry -l failed"
    pkill -9 -f "httpry -s"
    rm -f index* tmp.txt tmp.log
    # test -P
    httpry -n 2 -P PID -o tmp.log -b tmp.txt -d
    for((i=1;i<=3;i++)); do
        curl www.baidu.com
    done
    SLEEP_WAIT 2
    grep "baidu" tmp.txt
    CHECK_RESULT $? 0 0 "Check httpry -P failed"
    pkill -9 -f "httpry -n"
    rm -f index* tmp.txt tmp.log
    # test -u
    useradd testdemo
    httpry -n 2 -o tmp.log -u testdemo -b tmp.txt -d
    for((i=1;i<=3;i++)); do
        curl www.baidu.com
    done
    SLEEP_WAIT 2
    grep "baidu" tmp.txt
    CHECK_RESULT $? 0 0 "Check httpry -u failed"
    pkill -9 -f "httpry -n"
    rm -f index* tmp.txt tmp.log
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f /tmp/a.out
    LOG_INFO "End to restore the test environment."
}

main "$@"
