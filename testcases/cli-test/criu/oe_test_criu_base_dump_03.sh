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
    mkdir checkpoint_file checkpoint_file_2
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
    (test_process) & criu dump -D checkpoint_file -j -t $! --evasive-devices
    CHECK_RESULT $? 0 0 "Check criu dump --evasive-devices failed"
    (test_process) & criu dump -D checkpoint_file -j -t $! --link-remap
    CHECK_RESULT $? 0 0 "Check criu dump --link-remap failed"
    (test_process) & criu dump -D checkpoint_file -j -t $! --ghost-limit size
    CHECK_RESULT $? 0 0 "Check criu dump --ghost-limit failed"
    (test_process) & criu dump -D checkpoint_file -j -t $! -l
    CHECK_RESULT $? 0 0 "Check criu dump -l failed"
    (test_process) & criu dump -D checkpoint_file -j -t $! --file-locks
    CHECK_RESULT $? 0 0 "Check criu dump --file-locks failed"
    (test_process) & criu dump -D checkpoint_file -j -t $! -L /
    CHECK_RESULT $? 0 0 "Check criu dump -L failed"
    (test_process) & criu dump -D checkpoint_file -j -t $! --libdir /
    CHECK_RESULT $? 0 0 "Check criu dump --libdir failed"
    (test_process) & criu dump -D checkpoint_file -j -t $! --force-irmap
    CHECK_RESULT $? 0 0 "Check criu dump --force-irmap failed"
    (test_process) & criu dump -D checkpoint_file -j -t $! --irmap-scan-path FILE
    CHECK_RESULT $? 0 0 "Check criu dump --irmap-scan-path failed"
    (test_process) & criu dump -D checkpoint_file -j -t $! --manage-cgroups
    CHECK_RESULT $? 0 0 "Check criu dump --manage-cgroups failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf checkpoint_file checkpoint_file_2
    LOG_INFO "End to restore the test environment."
}

main "$@"