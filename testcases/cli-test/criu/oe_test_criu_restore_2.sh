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
    cd checkpoint_file
    (test_process) & pid=$! && DUMP
    criu restore -j --external dev & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --external failed"
    criu restore -j --tcp-established & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --tcp-established failed"
    criu restore -j --skip-in-flight & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --skip-in-flight failed"
    criu restore -j --tcp-close & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --tcp-close failed"
    criu restore -j -r / & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore -r failed"
    criu restore -j --evasive-devices & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --evasive-devices failed"
    criu restore -j --link-remap & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --link-remap failed"
    criu restore -j --ghost-limit size & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --ghost-limit failed"
    criu restore -j -l & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore -l failed"
    cd ..
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf checkpoint_file
    LOG_INFO "End to restore the test environment."
}

main "$@"