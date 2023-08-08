#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   huangjiayi
# @Contact   :   1960887351@qq.com
# @Date      :   2022/8/22
# @License   :   Mulan PSL v2
# @Desc      :   Test "criu" command
# ##################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test(){
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "criu"
    mkdir checkpoint_file
    test_process(){
        num=0
        while true;
        do
            echo -e "$num PID, BASHPID, 和PPID是$$, $BASHPID, $PPID"
            (( num += 1 ))
            sleep 1
        done
    }
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    criu -V | grep -E "Version: 3.15"
    CHECK_RESULT $? 0 0 "Check -V failed."
    criu --version | grep -E "Version: 3.15"
    CHECK_RESULT $? 0 0 "Check --version failed."
    (test_process) & criu dump -D checkpoint_file -j -t $! --with-cpu-affinity
    CHECK_RESULT $? 0 0 "Check criu dump --with-cpu-affinity failed"
    criu service --tls-cacert FILE &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f "criu service")
    CHECK_RESULT $? 0 0 "Check criu service --tls-cacert failed"
    criu service --tls-cacrl FILE &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f "criu service")
    CHECK_RESULT $? 0 0 "Check criu service --tls-cacrl failed"
    criu service --tls-cert FILE &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f "criu service")
    CHECK_RESULT $? 0 0 "Check criu service --tls-cert failed"
    criu service --tls-key FILE &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f "criu service")
    CHECK_RESULT $? 0 0 "Check criu service --tls-key failed"
    criu service --tls-no-cn-verify &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f "criu service")
    CHECK_RESULT $? 0 0 "Check criu service --tls-no-cn-verify failed"
    criu page-server --tls-cacert FILE &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f "criu page-server")
    CHECK_RESULT $? 0 0 "Check criu page-server --tls-cacert failed"
    criu page-server --tls-cacrl FILE &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f "criu page-server")
    CHECK_RESULT $? 0 0 "Check criu page-server --tls-cacrl failed"
    criu page-server --tls-cert FILE &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f "criu page-server")
    CHECK_RESULT $? 0 0 "Check criu page-server --tls-cert failed"
    criu page-server --tls-key FILE &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f "criu page-server")
    CHECK_RESULT $? 0 0 "Check criu page-server --tls-key failed"
    criu page-server --tls-no-cn-verify &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f "criu page-server")
    CHECK_RESULT $? 0 0 "Check criu page-server --tls-no-cn-verify failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf checkpoint_file
    LOG_INFO "End to restore the test environment."
}

main "$@"