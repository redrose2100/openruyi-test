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
# @Author    :   hanliyi
# @Contact   :   1032864780@qq.com
# @Date      :   2022/09/30
# @License   :   Mulan PSL v2
# @Desc      :   TEST mikmod options
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# Data and parameter configuration that need to be preloaded
function config_params() {
    LOG_INFO "Start to config params of the case."

    TMP_DIR="$(mktemp -d -t mikmod.XXXXXXXXXXXX)"

    LOG_INFO "End to config params of the case."
}

#Installation preparation for test objects, tools required for testing, etc.
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    
    modprobe snd-dummy
    DNF_INSTALL "mikmod"

    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."

    mikmod -h | grep -q "Usage"
    CHECK_RESULT $? 0 0 "option: -h[elp] error"
    mikmod --help | grep -q "Usage"
    CHECK_RESULT $? 0 0 "option: --help error"

    mikmod -V | grep -q "\-=.*=-"
    CHECK_RESULT $? 0 0 "option: -V error"
    mikmod -version | grep -q "\-=.*=-"
    CHECK_RESULT $? 0 0 "option: -version error"

    mikmod -n | grep -q "drivers"
    CHECK_RESULT $? 0 0 "option: -n error"
    mikmod -information | grep -q "drivers"
    CHECK_RESULT $? 0 0 "option: -in[formation] error"
    DRIVER_NUM="$(mikmod -n | grep -B 100 "Recognized" | grep -cE "^[ 0-9]")"

    # Test the -N,-drvinfo parameter
    for ((i=1; i<=${DRIVER_NUM}; i++))
    do
        mikmod -N ${i} | grep "Parameter list"
        CHECK_RESULT $? 0 0 "option: -N ${i} error"
        mikmod -drvinfo ${i} | grep "Parameter list"
        CHECK_RESULT $? 0 0 "option: -drvinfo ${i} error"
    done

    # Test the -d[river] parameter
    cd ${TMP_DIR}
    for ((i=0; i<=${DRIVER_NUM}; i++))
    do
        echo "Q" | mikmod -d $i > /dev/null && cat ~/.mikmodrc | grep -q "DRIVER = ${i}"
        CHECK_RESULT $? 0 0 "option: -d[river] ${i} error"
    done
    cd -
    
    LOG_INFO "End to run test."
}

# Post-processing, restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."

    modprobe -r snd-dummy
    rm -rf ~/.mikmod* ${TMP_DIR}
    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"