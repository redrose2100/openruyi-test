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
# @Desc      :   Test sctp_test
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
    sctp_test -H ::1 -P 6000 -l -d 1 -x 1 -i "lo" > server_output 2>&1 &
    server_pid="$!"
    SLEEP_WAIT 2
    cat server_output | grep "Server: Receiving packets."
    CHECK_RESULT $? 0 0 "sctp_test: failed to test server"
    kill -9 $server_pid
    sctp_test -H ::1 -P 6010 -h ::1 -p 7000 -l -L 2 -S 2 -a 0 > server_output 2>&1 &
    server_pid="$!"
    SLEEP_WAIT 2
    cat server_output | grep "Starting tests..."
    CHECK_RESULT $? 0 0 "sctp_test: failed to test server options: -L, -S, -a"
    kill -9 $server_pid
    unbuffer sctp_darn -H ::1 -P 6000 -l > server_output 2>&1 &
    server_pid="$!"
    sctp_test -H ::1 -P 7000 -h ::1 -p 6000 -s -c 0 -o 0 -d 1 > client_output 2>&1 &
    client_pid="$!"
    SLEEP_WAIT 2
    kill -9 $client_pid
    cat client_output | grep "Client: Sending packets"
    CHECK_RESULT $? 0 0 "sctp_test: failed to test client options: -c, -o, -d"
    sctp_test -H ::1 -P 7000 -h ::1 -p 6000 -L 2 -S 2 -a 0 > client_output 2>&1 &
    client_pid="$!"
    SLEEP_WAIT 2
    kill -9 $client_pid
    cat client_output | grep "sendmsg"
    CHECK_RESULT $? 0 0 "sctp_test: failed to test client options: -L, -S, -a"
    sctp_test -H ::1 -P 7000 -h ::1 -p 6000 -s -m 1500 -t 0 -M 0 > client_output 2>&1 &
    client_pid="$!"
    SLEEP_WAIT 2
    kill -9 $client_pid
    cat client_output | grep "Client: Sending packets"
    CHECK_RESULT $? 0 0 "sctp_test: failed to test client options: -m, -t, -M"
    sctp_test -H ::1 -P 7000 -h ::1 -p 6000 -s -r -D -T > client_output 2>&1 &
    client_pid="$!"
    SLEEP_WAIT 2
    kill -9 $client_pid
    cat client_output | grep "Client: Sending packets"
    CHECK_RESULT $? 0 0 "sctp_test: failed to test client options: -r, -D, -T"
    sctp_test -H ::1 -P 7000 -h ::1 -p 6000 -s -B 127.0.0.2 -O 0 -i "lo" > client_output 2>&1 &
    client_pid="$!"
    SLEEP_WAIT 2
    kill -9 $client_pid
    cat client_output | grep "Client: Sending packets"
    CHECK_RESULT $? 0 0 "sctp_test: failed to test client options: -B, -O, -i"
    sctp_test -H ::1 -P 7000 -h ::1 -p 6000 -s -x 1 > client_output 2>&1 &
    client_pid="$!"
    SLEEP_WAIT 2
    kill -9 $client_pid
    cat client_output | grep "(1/1)"
    CHECK_RESULT $? 0 0 "sctp_test: failed to test client option: -x"
    kill -9 $server_pid
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -f server_output client_output
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
