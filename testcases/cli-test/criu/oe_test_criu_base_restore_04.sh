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
    criu restore -j --cgroup-props-file FILE & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --cgroup-props-file failed"
    criu restore -j --cgroup-dump-controller NAME & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --cgroup-dump-controller failed"
    criu restore -j --cgroup-yard PATH & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --cgroup-yard failed"
    criu restore -j --skip-mnt PATH & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --skip-mnt failed"
    criu restore -j --enable-fs FSNAMES & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --enable-fs failed"
    criu restore -j --empty-ns net & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --empty-ns net failed"
    criu restore -j --file-validation filesize & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --file-validation failed"
    criu restore -j --with-cpu-affinity & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --with-cpu-affinity failed"
    criu restore -j --track-mem & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --track-mem failed"
    criu restore -j --page-server & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --page-server failed"
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