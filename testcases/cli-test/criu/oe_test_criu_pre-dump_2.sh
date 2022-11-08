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

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --external dev && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --external No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --tcp-established && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --tcp-established No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --skip-in-flight && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --skip-in-flight No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --tcp-close && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --tcp-close No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid -r / && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump -r No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --evasive-devices && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --evasive-devices No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --link-remap && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --link-remap No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --ghost-limit size && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --ghost-limit No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --action-script FILE && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --action-script No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid -l && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump -l No Pass"

    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf checkpoint_file
    LOG_INFO "End to restore the test environment."
}

main "$@"