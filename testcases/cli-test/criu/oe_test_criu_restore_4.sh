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
    DUMP(){
        sleep 0.1
        criu dump -j -t $pid
    }
    cd checkpoint_file
    (test_process) & pid=$! && DUMP

    criu restore -j --lsm-mount-context CTX & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --lsm-mount-context No Pass"

    criu restore -j --skip-mnt PATH & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --skip-mnt No Pass"

    criu restore -j --enable-fs FSNAMES & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --enable-fs No Pass"

    # criu restore -j --inherit-fd fd[NUM]:RES & DUMP
    # CHECK_RESULT $? 0 0 "L$LINENO: restore --inherit-fd No Pass"

    criu restore -j --empty-ns net & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --empty-ns net No Pass"

    # criu restore -j -J NS:{PID|NS_FILE}[,OPTIONS] & DUMP
    # CHECK_RESULT $? 0 0 "L$LINENO: restore -J No Pass"

    criu restore -j --file-validation filesize & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --file-validation No Pass"

    criu restore -j --with-cpu-affinity & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --with-cpu-affinity No Pass"

    # criu restore -j --pin-memory & DUMP
    # CHECK_RESULT $? 0 0 "L$LINENO: restore --pin-memory No Pass"

    criu restore -j --track-mem & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --track-mem No Pass"

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