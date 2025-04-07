#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2023/7/22
# @License   :   Mulan PSL v2
# @Desc      :   Test "criu" command
# ##################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test(){
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "criu"
    if criu check --experimental | grep "Looks good but some kernel features are missing"; then
        echo "The environment is not support!"
        exit 0
    fi
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
    cd checkpoint_file || exit
    (test_process) & pid=$! && criu pre-dump -j -t $! && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump -j -t failed"
    (test_process) & pid=$! && criu pre-dump --shell-job -t $! && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --shell-job failed"
    (test_process) & pid=$! && criu pre-dump -j --tree $! && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump -j --tree failed"
    (test_process) & pid=$! && criu pre-dump --pidfile FILE -j -t $! && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --pidfile failed"
    cd .. || exit
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump -D failed"
    (test_process) & pid=$! && criu pre-dump --images-dir checkpoint_file -j -t $pid && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --images-dir failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid -s && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump -s failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --leave-stopped && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --leave-stopped failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid -R && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump -R failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --leave-running && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --leave-running failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf checkpoint_file
    LOG_INFO "End to restore the test environment."
}

main "$@"
