#!/usr/bin/bash

# Copyright (c) 2022. Lanzhou University of Technology.,Univ.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   GaoNan ZhouZhenBin WuXiChuan
# @Contact   :   690895849@qq.com
# @Date      :   2022/09/30
# @License   :   Mulan PSL v2
# @Desc      :   TEST libnice stund
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# Installation Preparation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libnice net-tools"
    LOG_INFO "End to prepare the test environment."
}

# Execution of  test points
function run_test() {
    LOG_INFO "Start to run test."
    declare -A PID
    # Assign a port number that may not be used
    PORT=$((32768+$$))
    if test $PORT -le 1024; then
        PORT=$(($PORT+1024))
    fi
    # Start the stund
    for v in 4 6 
    do
        stund -${v} ${PORT} &
        PID[${v}]=$!
    done
    netstat -unlp | grep -q stund
    CHECK_RESULT $? 0 0 "stund run error"
    # kill stund
    for v in 4 6; do 
        kill -INT ${PID[${v}]}
    done
    LOG_INFO "End to run test."
}

# Post processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"