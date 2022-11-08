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
        # while (( num < 5));
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
    
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --lsm-mount-context CTX && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --lsm-mount-context No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --skip-mnt PATH && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --skip-mnt No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --enable-fs FSNAMES && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --enable-fs No Pass"

    # (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --inherit-fd fd[NUM]:RES && kill -9 $pid
    # CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --inherit-fd No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --empty-ns net && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --empty-ns net No Pass"

    # (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid -J NS:{PID|NS_FILE}[,OPTIONS] && kill -9 $pid
    # CHECK_RESULT $? 0 0 "L$LINENO: pre-dump -J No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --file-validation filesize && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --file-validation No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --with-cpu-affinity && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --with-cpu-affinity No Pass"

    # (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --pin-memory && kill -9 $pid
    # CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --pin-memory No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --track-mem && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --track-mem No Pass"

    LOG_INFO "End to run test."
}


function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf checkpoint_file
    LOG_INFO "End to restore the test environment."
}

main "$@"