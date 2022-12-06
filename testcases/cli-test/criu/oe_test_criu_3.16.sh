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
    DUMP(){
        sleep 0.1
        criu dump -j -t $pid
    }
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    (test_process) & criu dump -D checkpoint_file -j -t $! --network-lock iptables
    CHECK_RESULT $? 0 0 "Check criu dump --network-lock failed"
    (test_process) & criu dump -D checkpoint_file -j -t $! --lsm-mount-context CTX
    CHECK_RESULT $? 0 0 "Check criu dump --lsm-mount-context failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --network-lock iptables && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --network-lock failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --lsm-mount-context CTX && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --lsm-mount-context failed"
    cd checkpoint_file
    (test_process) & pid=$! && DUMP
    criu restore -j --network-lock iptables & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --network-lock failed"
    criu restore -j --lsm-mount-context CTX & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --lsm-mount-context failed"
    cd ..
    criu -V | grep -E "Version: 3.16.1"
    CHECK_RESULT $? 0 0 "Check -V failed."
    criu --version | grep -E "Version: 3.16.1"
    CHECK_RESULT $? 0 0 "Check --version failed."
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf checkpoint_file
    LOG_INFO "End to restore the test environment."
}

main "$@"