#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhoulimin
# @Contact   :   limin@isrc.iscas.ac.cn 
# @Date      :   2022-09-07
# @License   :   Mulan PSL v2
# @Desc      :   The test of dejagnu package 
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment!"
    DNF_INSTALL dejagnu
    test -d tmp || mkdir tmp
    ARCH=$(uname -m)
    if [[ "$ARCH" == "x86_64" ]]; then
        CALC=common/calc_x86_64
    elif [[ "$ARCH" == "riscv64" ]]; then
        CALC=common/calc_riscv64
    elif [[ "$ARCH" == "aarch64" ]]; then
	    CALC=common/calc_aarch64    
    else
        LOG_ERROR "Unsupported architecture: $ARCH"
        exit 1
    fi
    LOG_INFO "End to prepare the test environment!"
}

function run_test() {
    LOG_INFO "Start to run test."
    runtest CALC=${CALC} --objdir common --srcdir common --outdir tmp 2>&1 | grep "expected passes"
    CHECK_RESULT $? 0 0 "Failed option : --objdir"
    rm -rf tmp/*
    runtest CALC=${CALC} --srcdir common --outdir tmp
    test -f ./tmp/testrun.log
    CHECK_RESULT $? 0 0 "Failed option : --outdir or --srcdir"
    runtest CALC=${CALC} --srcdir common -v --reboot --outdir tmp 2>&1 | grep "Will reboot the target (if supported)"
    CHECK_RESULT $? 0 0 "Failed option : --reboot"
    runtest CALC=${CALC} --strace 1 --srcdir common --outdir tmp 2>&1 | grep -m 1 "log_and_exit"
    CHECK_RESULT $? 0 0 "Failed option : --strace"
    runtest CALC=${CALC} -v --tool version --srcdir common --outdir tmp 2>&1 | grep "Testing version"
    CHECK_RESULT $? 0 0 "Failed option : --tool"
    runtest CALC=${CALC} -v --D0 --srcdir common --outdir tmp 2>&1 | grep "Tcl debugger is ON"
    CHECK_RESULT $? 0 0 "Failed option : --D"
    rm -rf tmp/*
    runtest CALC=${CALC} --xml --srcdir common --outdir tmp
    test -f ./tmp/testrun.xml
    CHECK_RESULT $? 0 0 "Failed option : --xml"
    rm -rf tmp/*
    runtest CALC=${CALC} -x --srcdir common --outdir tmp
    test -f ./tmp/testrun.xml
    CHECK_RESULT $? 0 0 "Failed option : -x"
    runtest CALC=${CALC} -v --script.exp --srcdir common --outdir tmp 2>&1 | grep "Running only tests --script.exp" 
    CHECK_RESULT $? 0 0 "Failed option : --script.exp"
    runtest CALC=${CALC} -v --target_boards=unix --srcdir common --outdir tmp 2>&1 | grep "Running target unix"
    CHECK_RESULT $? 0 0 "Failed option : --target_boards"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    rm -rf tmp ./*.sum ./*.log
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
