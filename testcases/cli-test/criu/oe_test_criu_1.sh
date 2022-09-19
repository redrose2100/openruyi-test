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

    criu -h | grep -E "Usage:"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"

    criu -V | grep -E "Version: [[:digit:]]*.[[:digit:]]*.[[:digit:]]*"
    CHECK_RESULT $? 0 0 "L$LINENO: -V No Pass"
    
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
    (test_process) & criu dump -j -t $! 
    cd ..
    CHECK_RESULT $? 0 0 "L$LINENO: dump -j -t No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $!
    CHECK_RESULT $? 0 0 "L$LINENO: dump -D No Pass"
    
    (test_process) & criu dump -D checkpoint_file -j -t $! -s
    CHECK_RESULT $? 0 0 "L$LINENO: dump -s No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! -R
    CHECK_RESULT $? 0 0 "L$LINENO: dump -R No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! -W checkpoint_file
    CHECK_RESULT $? 0 0 "L$LINENO: dump -W No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --cpu-cap
    CHECK_RESULT $? 0 0 "L$LINENO: dump --cpu-cap No Pass"

    # (test_process) & criu dump -D checkpoint_file -j -t $! --freeze-cgroup
    # CHECK_RESULT $? 0 0 "L$LINENO: dump --freeze-cgroup No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --weak-sysctls
    CHECK_RESULT $? 0 0 "L$LINENO: dump --weak-sysctls No Pass"

    # (test_process) & criu dump -D checkpoint_file -j -t $! --stream
    # CHECK_RESULT $? 0 0 "L$LINENO: dump --stream No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --network-lock iptables
    CHECK_RESULT $? 0 0 "L$LINENO: dump --network-lock No Pass"

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

    (test_process) & criu dump -D checkpoint_file -j -t $! -L /
    CHECK_RESULT $? 0 0 "L$LINENO: dump -L No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --force-irmap
    CHECK_RESULT $? 0 0 "L$LINENO: dump --force-irmap No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --irmap-scan-path FILE
    CHECK_RESULT $? 0 0 "L$LINENO: dump --irmap-scan-path No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --manage-cgroups
    CHECK_RESULT $? 0 0 "L$LINENO: dump --manage-cgroups No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --cgroup-root /
    CHECK_RESULT $? 0 0 "L$LINENO: dump --cgroup-root No Pass"

    # (test_process) & criu dump -D checkpoint_file -j -t $! --cgroup-props STRING
    # CHECK_RESULT $? 0 0 "L$LINENO: dump --cgroup-props STRING No Pass"

    # (test_process) & criu dump -D checkpoint_file -j -t $! --cgroup-props-file FILE
    # CHECK_RESULT $? 0 0 "L$LINENO: dump --cgroup-props-file STRING No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --cgroup-dump-controller NAME
    CHECK_RESULT $? 0 0 "L$LINENO: dump --cgroup-dump-controller No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --cgroup-yard PATH
    CHECK_RESULT $? 0 0 "L$LINENO: dump --cgroup-yard No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --lsm-profile selinux:NAME
    CHECK_RESULT $? 0 0 "L$LINENO: dump --lsm-profile No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --lsm-mount-context CTX
    CHECK_RESULT $? 0 0 "L$LINENO: dump --lsm-mount-context No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --skip-mnt PATH
    CHECK_RESULT $? 0 0 "L$LINENO: dump --skip-mnt No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --enable-fs FSNAMES
    CHECK_RESULT $? 0 0 "L$LINENO: dump --enable-fs No Pass"

    # (test_process) & criu dump -D checkpoint_file -j -t $! --inherit-fd fd[NUM]:RES
    # CHECK_RESULT $? 0 0 "L$LINENO: dump --inherit-fd No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --empty-ns net
    CHECK_RESULT $? 0 0 "L$LINENO: dump --empty-ns net No Pass"

    # (test_process) & criu dump -D checkpoint_file -j -t $! -J NS:{PID|NS_FILE}[,OPTIONS]
    # CHECK_RESULT $? 0 0 "L$LINENO: dump -J No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --file-validation filesize
    CHECK_RESULT $? 0 0 "L$LINENO: dump --file-validation No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --with-cpu-affinity
    CHECK_RESULT $? 0 0 "L$LINENO: dump --with-cpu-affinity No Pass"

    # (test_process) & criu dump -D checkpoint_file -j -t $! --pin-memory
    # CHECK_RESULT $? 0 0 "L$LINENO: dump --pin-memory No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --track-mem
    CHECK_RESULT $? 0 0 "L$LINENO: dump --track-mem No Pass"

    pre_name='checkpoint_file' && pre_path=$(readlink -f $pre_name)
    (test_process) & pid=$! && criu pre-dump -D checkpoint_file -j -t $pid
    criu dump -D checkpoint_file_2 -j -t $pid --prev-images-dir $pre_path
    CHECK_RESULT $? 0 0 "L$LINENO: dump --prev-images-dir No Pass"

    # (test_process) & criu dump -D checkpoint_file -j -t $! --page-server
    # CHECK_RESULT $? 0 0 "L$LINENO: dump --page-server No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --auto-dedup
    CHECK_RESULT $? 0 0 "L$LINENO: dump --auto-dedup No Pass"

    (test_process) & criu dump -D checkpoint_file -j -t $! --pre-dump-mode splice
    CHECK_RESULT $? 0 0 "L$LINENO: dump --pre-dump-mode No Pass"

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