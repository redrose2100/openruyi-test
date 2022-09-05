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
# @Desc      :   Test sctp_darn
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
    unbuffer sctp_darn -H ::1 -P 6000 -l -B 127.0.0.2 -B 127.0.0.3 -b 127.0.0.3 -c 127.0.0.4 > server_output 2>&1 &
    server_pid=$!
    SLEEP_WAIT 2
    echo "hello" | sctp_darn -H ::1 -P 7000 -h ::1 -p 6000 -s
    SLEEP_WAIT 2
    cat server_output | grep 'hello'
    CHECK_RESULT $? 0 0 "sctp_darn: failed to test options: -H, -P, -h, -p, -s, -l, -B, -b, -c"
    kill -9 $server_pid
    rm -rf server_output
    unbuffer sctp_darn -H ::1 -P 6010 -l > server_output 2>&1 &
    server_pid=$!
    SLEEP_WAIT 2
    echo "hello" | sctp_darn -H ::1 -P 7010 -h ::1 -p 6010 -s -t -z 8 --interface="lo"
    SLEEP_WAIT 2
    cat server_output | grep 'hello'
    CHECK_RESULT $? 0 0 "sctp_darn: failed to test options: -t, -z, --interface"
    kill -9 $server_pid
    rm -rf server_output
    unbuffer sctp_darn -H ::1 -P 6030 -l -m 16 -i 2 --use-poll > server_output 2>&1 &
    server_pid=$!
    SLEEP_WAIT 2
    echo "hello" | sctp_darn -H ::1 -P 7030 -h ::1 -p 6030 -s
    SLEEP_WAIT 2
    cat server_output | grep 'No association is present in sk No.1 now'
    CHECK_RESULT $? 0 0 "sctp_darn: failed to test options: -m, -i, --use-poll"
    kill -9 $server_pid
    rm -rf server_output
    echo "?" | sctp_darn -H ::1 -P 6040 -l -n -I > server_output 2>&1
    cat server_output | grep "Interactive commands:"
    CHECK_RESULT $? 0 0 "sctp_darn: failed to test interactive command '?'"
    rm -rf server_output
    unbuffer sctp_darn -H ::1 -P 6040 -l > server_output 2>&1 &
    server_pid=$!
    SLEEP_WAIT 2
    echo "snd=8" | sctp_darn -H ::1 -P 7040 -h ::1 -p 6040 -s -I
    SLEEP_WAIT 2
    cat server_output | grep "DATA(8):"
    CHECK_RESULT $? 0 0 "sctp_darn: failed to test interactive command 'snd=<int>'"
    kill -9 $server_pid
    rm -rf server_output
    mkfifo server_fifo
    tail -f server_fifo | sctp_darn -H ::1 -P 6050 -l -I > server_output 2>&1 &
    server_pid=$!
    SLEEP_WAIT 2
    echo "stats" > server_fifo
    SLEEP_WAIT 2
    tail server_output | grep "No association present yet"
    CHECK_RESULT $? 0 0 "sctp_darn: failed to test interactive command 'stats'"
    echo "hello" | sctp_darn -H ::1 -P 7050 -h ::1 -p 6050 -s
    echo -e "rcv=8\nrcv=8" > server_fifo
    SLEEP_WAIT 2
    cat server_output | grep "hello"
    CHECK_RESULT $? 0 0 "sctp_darn: failed to test interactive command 'rcv=<int>'"
    echo "shutdown" > server_fifo
    tail server_output | grep "SHUTDOWN"
    CHECK_RESULT $? 0 0 "sctp_darn: failed to test interactive command 'shutdown'"
    echo "abort" > server_fifo
    tail server_output | grep "ABORT"
    CHECK_RESULT $? 0 0 "sctp_darn: failed to test interactive command 'abort'"
    kill -9 $server_pid
    echo "bindx-add=127.0.0.1" | sctp_darn -H ::1 -P 6000 -l -I > server_output 2>&1
    cat server_output | grep "Invalid input."
    CHECK_RESULT $? 1 0 "sctp_darn: failed to test interactive command 'bindx-add=<addr>'"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf server_fifo server_output
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
