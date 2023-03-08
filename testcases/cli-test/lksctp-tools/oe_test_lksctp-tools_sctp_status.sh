#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   hantingxiang
# @Contact   :   hantingxiang@gmail.com
# @Date      :   2022/08/01
# @License   :   Mulan PSL v2
# @Desc      :   Test sctp_status
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL lksctp-tools
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    sctp_status -H ::1 -P 6000 -l -i 0 -d 1 -f server_output &
    server_pid=$!
    SLEEP_WAIT 2
    (echo "hello" && cat) | sctp_darn -H ::1 -P 7000 -h ::1 -p 6000 -s &
    client_pid=$!
    SLEEP_WAIT 2
    cat server_output | grep 'ESTABLISHED'
    CHECK_RESULT $? 0 0 "sctp_status: failed to test options: -i, -d, -f"
    kill -9 $server_pid
    kill -9 $client_pid
    sctp_darn -H ::1 -P 6010 -l > /dev/null 2>&1 &
    server_pid=$!
    SLEEP_WAIT 2
    sctp_status -H ::1 -P 7010 -h ::1 -p 6010 -s -c 0 -o 0 -f client_output &
    client_pid=$!
    SLEEP_WAIT 2
    cat client_output | grep 'ESTABLISHED'
    CHECK_RESULT $? 0 0 "sctp_status: failed to test options: -c, -o, -f"
    kill -9 $client_pid
    sctp_status -H ::1 -P 7020 -h ::1 -p 6010 -s -x 1 > client_output 2>&1 &
    client_pid=$!
    SLEEP_WAIT 2
    cat client_output | grep '(1/1)'
    CHECK_RESULT $? 0 0 "sctp_status: failed to test option: -x"
    kill -9 $client_pid
    sctp_status -H ::1 -P 7030 -h ::1 -p 6010 -s -M 0 -m 1500 -D > client_output 2>&1 &
    client_pid=$!
    SLEEP_WAIT 2
    cat client_output | grep 'Starting tests...'
    CHECK_RESULT $? 0 0 "sctp_status: failed to test options: -M, -m, -o"
    kill -9 $client_pid
    sctp_status -H ::1 -P 7040 -h ::1 -p 6010 -s -I 1 -i 0 -d 1 > client_output 2>&1 &
    client_pid=$!
    SLEEP_WAIT 2
    cat client_output | grep 'Starting tests...'
    CHECK_RESULT $? 0 0 "sctp_status: failed to test options: -I, -i, -d"
    kill -9 $client_pid
    kill -9 $server_pid
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf server_output client_output
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
