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
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid -L / && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump -L failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --force-irmap && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --force-irmap failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --irmap-scan-path FILE && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --irmap-scan-path failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --manage-cgroups && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --manage-cgroups failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --cgroup-root / && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --cgroup-root failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --cgroup-props STRING && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --cgroup-props STRING failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --cgroup-props-file FILE && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --cgroup-props-file STRING failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --cgroup-dump-controller NAME && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --cgroup-dump-controller failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --cgroup-yard PATH && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --cgroup-yard failed"
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --lsm-profile selinux:NAME && kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu pre-dump --lsm-profile failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf checkpoint_file
    LOG_INFO "End to restore the test environment."
}

main "$@"