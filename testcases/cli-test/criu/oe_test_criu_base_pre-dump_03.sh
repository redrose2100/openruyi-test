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
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --evasive-devices && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --evasive-devices failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --link-remap && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --link-remap failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --ghost-limit size && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --ghost-limit failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --action-script FILE && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --action-script failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid -l && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump -l failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --file-locks && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --file-locks failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid -L / && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump -L failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --libdir / && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --libdir failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --force-irmap && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --force-irmap failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --irmap-scan-path FILE && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --irmap-scan-path failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf checkpoint_file
    LOG_INFO "End to restore the test environment."
}

main "$@"
