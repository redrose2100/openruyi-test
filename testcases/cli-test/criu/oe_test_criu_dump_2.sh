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
    mkdir checkpoint_file_2

    LOG_INFO "End to prepare the test environment."
}
##########################################################
# Usage:
#   criu dump|pre-dump -t PID [<options>]
#   criu restore [<options>]
#   criu check [--feature FEAT]
#   criu page-server
#   criu service [<options>]
#   criu dedup
#   criu lazy-pages -D DIR [<options>]

# Commands:
#   dump           checkpoint a process/tree identified by pid
#   pre-dump       pre-dump task(s) minimizing their frozen time
#   restore        restore a process/tree
#   check          checks whether the kernel support is up-to-date
#   page-server    launch page server
#   service        launch service
#   dedup          remove duplicates in memory dump
#   cpuinfo dump   writes cpu information into image file
#   cpuinfo check  validates cpu information read from image file

# Try -h|--help for more info
##########################################################
function run_test(){
    LOG_INFO "Start to run test."

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
    (test_process) & criu dump -D checkpoint_file -j -t $! --external dev
    CHECK_RESULT $? 0 0 "L$LINENO: dump --external No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --tcp-established
    CHECK_RESULT $? 0 0 "L$LINENO: dump --tcp-established No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --skip-in-flight
    CHECK_RESULT $? 0 0 "L$LINENO: dump --skip-in-flight No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --tcp-close
    CHECK_RESULT $? 0 0 "L$LINENO: dump --tcp-close No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! -r /
    CHECK_RESULT $? 0 0 "L$LINENO: dump -r No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --evasive-devices
    CHECK_RESULT $? 0 0 "L$LINENO: dump --evasive-devices No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --link-remap
    CHECK_RESULT $? 0 0 "L$LINENO: dump --link-remap No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --ghost-limit size
    CHECK_RESULT $? 0 0 "L$LINENO: dump --ghost-limit No Pass"

    # (test_process) & criu dump -D checkpoint_file -j -t $! --action-script FILE
    # CHECK_RESULT $? 0 0 "L$LINENO: dump --action-script No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! -l
    CHECK_RESULT $? 0 0 "L$LINENO: dump -l No Pass"

    LOG_INFO "End to run test."
}


function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf checkpoint_file
    rm -rf checkpoint_file_2
    LOG_INFO "End to restore the test environment."
}

main "$@"