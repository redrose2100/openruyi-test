#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   zhangjujie2
#@Contact   	:
#@Date      	:
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test for nmon
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "nmon"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    # option -x
    nmon -x
    SLEEP_WAIT 1
    grep 'interval,900' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -x"
    grep 'snapshots,96' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -x"
    grep 'TOP' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -x"
    rm *.nmon
    # option -X
    nmon -X
    SLEEP_WAIT 1
    grep 'interval,30' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -X"
    grep 'snapshots,120' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -X"
    grep 'TOP' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -X"
    rm *.nmon
    # option -z
    mkdir -p /var/perf/tmp/
    nmon -z
    test -f /var/perf/tmp/*.nmon
    CHECK_RESULT $? 0 0 "Failed option: -z"
    CHECK_RESULT "$(ls -l /var/perf/tmp/* | grep .nmon | awk '{print $3}')" "root" 0 "Failed option: -z"
    grep 'interval,900' /var/perf/tmp/*.nmon
    CHECK_RESULT $? 0 0 "Failed option: -z"
    grep 'snapshots,96' /var/perf/tmp/*.nmon
    CHECK_RESULT $? 0 0 "Failed option: -z"
    SLEEP_WAIT 2
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start restore the test environment."
    rm -rf /var/perf/
    kill -USR2 $(pgrep -w nmon)
    DNF_REMOVE "nmon"
    LOG_INFO "End to restore the test environment."
}

main "$@"

