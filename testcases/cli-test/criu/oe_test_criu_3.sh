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

    criu restore -j & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore -j No Pass"
    
    criu restore -j -d & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore -d No Pass"

    criu restore -j -d -S & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore -S No Pass"

    cd ..
    criu restore -j -D checkpoint_file & cd checkpoint_file && DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore -D No Pass"

    cd ..
    criu restore -j -D checkpoint_file -W checkpoint_file & cd checkpoint_file && DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore -W No Pass"
    
    criu restore -j --exec-cmd echo 'exec-cmd test' & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --exec-cmd No Pass"

    # criu restore -j --freeze-cgroup & DUMP
    # CHECK_RESULT $? 0 0 "L$LINENO: restore --freeze-cgroup No Pass"

    criu restore -j --weak-sysctls & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --weak-sysctls No Pass"

    # criu restore -j --stream & DUMP
    # CHECK_RESULT $? 0 0 "L$LINENO: restore --stream No Pass"

    criu restore -j --network-lock iptables & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --network-lock No Pass"

    criu restore -j --external dev & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --external No Pass"

    criu restore -j --tcp-established & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --tcp-established No Pass"

    criu restore -j --skip-in-flight & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --skip-in-flight No Pass"

    criu restore -j --tcp-close & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --tcp-close No Pass"

    criu restore -j -r / & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore -r No Pass"

    criu restore -j --evasive-devices & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --evasive-devices No Pass"

    criu restore -j --link-remap & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --link-remap No Pass"

    criu restore -j --ghost-limit size & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --ghost-limit No Pass"

    # criu restore -j --action-script FILE & DUMP
    # CHECK_RESULT $? 0 0 "L$LINENO: restore --action-script No Pass"

    criu restore -j -l & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore -l No Pass"

    criu restore -j -L / & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore -L No Pass"

    # criu restore -j --force-irmap & DUMP
    # CHECK_RESULT $? 0 0 "L$LINENO: restore --force-irmap No Pass"

    criu restore -j --irmap-scan-path FILE & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --irmap-scan-path No Pass"

    criu restore -j --manage-cgroups & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore -j --manage-cgroups No Pass"

    criu restore -j --cgroup-root / & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --cgroup-root No Pass"

    criu restore -j --cgroup-props STRING & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --cgroup-props No Pass"

    criu restore -j --cgroup-props-file FILE & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --cgroup-props-file No Pass"

    criu restore -j --cgroup-dump-controller NAME & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --cgroup-dump-controller No Pass"

    criu restore -j --cgroup-yard PATH & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --cgroup-yard No Pass"

    criu restore -j --lsm-profile selinux:NAME & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --lsm-profile No Pass"

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

    criu restore -j --page-server & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --page-server No Pass"

    criu restore -j --auto-dedup & DUMP
    CHECK_RESULT $? 0 0 "L$LINENO: restore --auto-dedup No Pass"

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