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
    cd checkpoint_file
    (test_process) & pid=$! && criu pre-dump -j -t $! && kill -9 $pid
    cd ..
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump -j -t No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump -D No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid -s && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump -s No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid -R && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump -R No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid -W checkpoint_file && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump -W No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --cpu-cap && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --cpu-cap No Pass"

    # (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --freeze-cgroup && kill -9 $pid
    # CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --freeze-cgroup No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --weak-sysctls && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --weak-sysctls No Pass"

    # (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $! --stream && kill -9 $pid
    # CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --stream No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --network-lock iptables && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --network-lock No Pass"

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

    # (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --action-script FILE && kill -9 $pid
    # CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --action-script No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid -l && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump -l No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid -L / && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump -L No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --force-irmap && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --force-irmap No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --irmap-scan-path FILE && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --irmap-scan-path No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --manage-cgroups && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --manage-cgroups No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --cgroup-root / && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --cgroup-root No Pass"

    # (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --cgroup-props STRING && kill -9 $pid
    # CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --cgroup-props STRING No Pass"

    # (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --cgroup-props-file FILE && kill -9 $pid
    # CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --cgroup-props-file STRING No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --cgroup-dump-controller NAME && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --cgroup-dump-controller No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --cgroup-yard PATH && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --cgroup-yard No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --lsm-profile selinux:NAME && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --lsm-profile No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --lsm-mount-context CTX && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --lsm-mount-context No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --skip-mnt PATH && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --skip-mnt No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --enable-fs FSNAMES && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --enable-fs No Pass"

    # (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --inherit-fd fd[NUM]:RES && kill -9 $pid
    # CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --inherit-fd No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --empty-ns net && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --empty-ns net No Pass"

    # (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid -J NS:{PID|NS_FILE}[,OPTIONS] && kill -9 $pid
    # CHECK_RESULT $? 0 0 "L$LINENO: pre-dump -J No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --file-validation filesize && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --file-validation No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --with-cpu-affinity && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --with-cpu-affinity No Pass"

    # (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --pin-memory && kill -9 $pid
    # CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --pin-memory No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --track-mem && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --track-mem No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --auto-dedup && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --auto-dedup No Pass"

    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid --pre-dump-mode splice && kill -9 $pid
    CHECK_RESULT $? 0 0 "L$LINENO: pre-dump --pre-dump-mode No Pass"

    LOG_INFO "End to run test."
}


function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf checkpoint_file
    LOG_INFO "End to restore the test environment."
}

main "$@"