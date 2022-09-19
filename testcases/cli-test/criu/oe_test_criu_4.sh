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
    
    criu check | grep 'Looks good'
    CHECK_RESULT $? 0 0 "L$LINENO: check default No Pass"

    criu check --extra | grep 'Looks good'
    CHECK_RESULT $? 0 0 "L$LINENO: check --extra No Pass"

    criu check --experimental | grep 'Looks good'
    CHECK_RESULT $? 0 0 "L$LINENO: check --experimental No Pass"

    criu check --all | grep 'Looks good'
    CHECK_RESULT $? 0 0 "L$LINENO: check --all No Pass"

    criu check --feature mnt_id | grep 'mnt_id is supported'
    CHECK_RESULT $? 0 0 "L$LINENO: check --feature No Pass"

    criu check -o FILE | grep 'Looks good'
    CHECK_RESULT $? 0 0 "L$LINENO: check -o No Pass"

    criu check -v | grep 'Looks good'
    CHECK_RESULT $? 0 0 "L$LINENO: check -v No Pass"

    criu check -vNUM | grep 'Looks good'
    CHECK_RESULT $? 0 0 "L$LINENO: check -vNUM No Pass"

    criu check --display-stats | grep 'Looks good'
    CHECK_RESULT $? 0 0 "L$LINENO: check --display-stats No Pass"

    criu page-server & kill -9 $!
    CHECK_RESULT $? 0 0 "L$LINENO: page-server No Pass"

    criu page-server --address 127.0.0.1 & kill -9 $!
    CHECK_RESULT $? 0 0 "L$LINENO: page-server --address No Pass"

    criu page-server --port 114514 & kill -9 $!
    CHECK_RESULT $? 0 0 "L$LINENO: page-server --port No Pass"

    # criu page-server --ps-socket FD & kill -9 $!
    # CHECK_RESULT $? 0 0 "L$LINENO: page-server --ps-socket No Pass"

    criu page-server -d & kill -9 $!
    CHECK_RESULT $? 0 0 "L$LINENO: page-server -d No Pass"

    criu page-server --status-fd \0 & kill -9 $!
    CHECK_RESULT $? 0 0 "L$LINENO: page-server --status-fd No Pass"

    criu service & kill -9 $!
    CHECK_RESULT $? 0 0 "L$LINENO: service No Pass"

    criu service --address ADDR & kill -9 $!
    CHECK_RESULT $? 0 0 "L$LINENO: service --address No Pass"

    criu service --port 114514 & kill -9 $!
    CHECK_RESULT $? 0 0 "L$LINENO: service --port No Pass"

    criu service --ps-socket FD & kill -9 $!
    CHECK_RESULT $? 0 0 "L$LINENO: service --ps-socket No Pass"

    criu service -d & kill -9 $!
    CHECK_RESULT $? 0 0 "L$LINENO: service -d No Pass"

    criu service --status-fd \0 & kill -9 $!
    CHECK_RESULT $? 0 0 "L$LINENO: service --status-fd No Pass"

    # criu dedup 
    # CHECK_RESULT $? 0 0 "L$LINENO: dedup No Pass"

    criu lazy-pages -D checkpoint_file & kill -9 $!
    CHECK_RESULT $? 0 0 "L$LINENO: --lazy-pages No Pass"

    criu cpuinfo dump
    CHECK_RESULT $? 0 0 "L$LINENO: cpuinfo dump No Pass"

    criu cpuinfo check
    CHECK_RESULT $? 0 0 "L$LINENO: cpuinfo check No Pass"

    criu check --config FILEPATH | grep 'Looks good'
    CHECK_RESULT $? 0 0 "L$LINENO: --config No Pass"

    criu check --no-default-config | grep 'Looks good'
    CHECK_RESULT $? 0 0 "L$LINENO: --no-default-config No Pass"

    criu -h | grep -E "Usage:"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"

    criu -V | grep -E "Version: [[:digit:]]*.[[:digit:]]*.[[:digit:]]*"
    CHECK_RESULT $? 0 0 "L$LINENO: -V No Pass"

    LOG_INFO "End to run test."
}


function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf checkpoint_file
    rm -rf FILE
    rm -rf cpuinfo.img
    LOG_INFO "End to restore the test environment."
}

main "$@"