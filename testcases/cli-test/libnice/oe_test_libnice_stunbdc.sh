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
# @Desc      :   TEST stunbdc connect stund
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# Installation Preparation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libnice net-tools"
    VERSION=$( rpm -qa libnice | awk -F '-''iprint $2}')
    PORT=$((32768+$$))
    if test $PORT -le 1024; then
        PORT=$(($PORT+1024))
    fi
    declare -A PID
    for v in 4 6
    do
        stund -${v} ${PORT} &
        PID[${v}]=$!
    done
    LOG_INFO "End to prepare the test environment."
}

# Execution of  test points
function run_test() {
    LOG_INFO "Start to run test."
    # -h,--h[elp]
    stunbdc -h | grep "Usage"
    CHECK_RESULT $? 0 0 "option: -h error"
    stunbdc --help | grep "Usage"
    CHECK_RESULT $? 0 0 "option: --h[elp] error"
    # -V,--v[ersion]
    stunbdc -V | grep "${VERSION}"
    CHECK_RESULT $? 0 0 "option: -V error"
    stunbdc --version | grep "${VERSION}"
    CHECK_RESULT $? 0 0 "option: --v[ersion] error"
    # stunbdc access stund
    stunbdc localhost ${PORT} | grep "Mapped"
    CHECK_RESULT $? 0 0 "stunbdc output error"
    stunbdc -4 127.0.0.1 ${PORT} | grep "127.0.0.1"
    CHECK_RESULT $? 0 0 "option: -4 error"
    stunbdc -6 ::1 ${PORT} | grep "::1"
    CHECK_RESULT $? 0 0 "option: -6 error"
    stunbdc -n 127.0.0.1 ${PORT} | grep "Mapped"
    CHECK_RESULT $? 0 0 "option: -n error"
    LOG_INFO "End to run test."
}

# Post processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    for v in 4 6; do
        kill -INT ${PID[${v}]}
    done
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"