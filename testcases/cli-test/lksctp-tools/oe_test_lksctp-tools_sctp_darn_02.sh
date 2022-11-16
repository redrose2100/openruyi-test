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
    echo -e "bindx-add=127.0.0.1\nbindx-rem=127.0.0.1" | sctp_darn -H ::1 -P 6000 -l -I > server_output 2>&1
    cat server_output | grep "Invalid input."
    CHECK_RESULT $? 1 0 "sctp_darn: failed to test interactive command 'bindx-add=<addr>'"
    echo "rcvbuf=8" | sctp_darn -H ::1 -P 6000 -l -I > server_output 2>&1
    cat server_output | grep "Invalid input."
    CHECK_RESULT $? 1 0 "sctp_darn: failed to test interactive command 'rcvbuf=<int>'"
    echo "sndbuf=8" | sctp_darn -H ::1 -P 7000 -h ::1 -p 6000 -l -I > client_output 2>&1
    cat server_output | grep "Invalid input."
    CHECK_RESULT $? 1 0 "sctp_darn: failed to test interactive command 'sndbuf=<int>'"
    echo "primary=127.0.0.1" | sctp_darn -H ::1 -P 6000 -l -I > server_output 2>&1
    cat server_output | grep "Invalid input."
    CHECK_RESULT $? 1 0 "sctp_darn: failed to test interactive command 'primary=<addr>'"
    echo "peer_primary=127.0.0.1" | sctp_darn -H ::1 -P 6000 -l -I > server_output 2>&1
    cat server_output | grep "Invalid input."
    CHECK_RESULT $? 1 0 "sctp_darn: failed to test interactive command 'peer_primary=<addr>'"
    echo "heartbeat=127.0.0.1" | sctp_darn -H ::1 -P 6000 -l -I > server_output 2>&1
    cat server_output | grep "Invalid input."
    CHECK_RESULT $? 1 0 "sctp_darn: failed to test interactive command 'heartbeat=<addr>'"
    echo "maxseg" | sctp_darn -H ::1 -P 6000 -l -I > server_output 2>&1
    SLEEP_WAIT 2
    cat server_output | grep "maxseg"
    CHECK_RESULT $? 0 0 "sctp_darn: failed to test interactive command 'maxseg=<int>'"
    echo -e "nodelay=1\nnodelay" | sctp_darn -H ::1 -P 6000 -l -I > server_output 2>&1
    SLEEP_WAIT 2
    cat server_output | grep "nodelay"
    CHECK_RESULT $? 0 0 "sctp_darn: failed to test interactive command 'nodelay=<0|1>'"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf client_output server_output
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
