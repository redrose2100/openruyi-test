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
    criu restore -j & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore -j failed"
    criu restore --shell-job & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --shell-job failed"
    criu restore -j -d & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore -d failed"
    criu restore -j --restore-detached & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --restore-detached failed"
    criu restore -j -d -S & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore -S failed"
    criu restore -j -d --restore-sibling & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --restore-sibling failed"
    cd ..
    criu restore -j -D checkpoint_file & cd checkpoint_file && DUMP
    CHECK_RESULT $? 0 0 "Check criu restore -D failed"
    cd ..
    criu restore -j --images-dir checkpoint_file & cd checkpoint_file && DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --images-dir failed"
    criu restore -j --pidfile FILE & DUMP
    CHECK_RESULT $? 0 0 "Check criu restore --pidfile failed"
    cd ..
    criu restore -j -D checkpoint_file -W checkpoint_file & cd checkpoint_file && DUMP
    CHECK_RESULT $? 0 0 "Check criu restore -W failed"
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