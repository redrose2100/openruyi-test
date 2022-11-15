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
# @Author    :   DingYaoyao
# @Contact   :   d1005562341@126.com
# @Date      :   2022/09/29
# @License   :   Mulan PSL v2
# @Desc      :   Test fftwf-wisdom
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "fftw"
    VERSION="$(rpm -qa fftw | awk -F '-' '{print $2}')"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    fftwf-wisdom -h 2>&1 | grep -q "Usage"
    CHECK_RESULT $? 0 0 "Check fftwf-wisdom -h failed."
    fftwf-wisdom --help 2>&1 | grep -q "Usage"
    CHECK_RESULT $? 0 0 "Check fftwf-wisdom --help failed."
    fftwf-wisdom -V 2>&1 | grep -q "${VERSION}"
    CHECK_RESULT $? 0 0 "Check fftwf-wisdom -V failed."
    fftwf-wisdom --version 2>&1 | grep -q "${VERSION}"
    CHECK_RESULT $? 0 0 "Check fftwf-wisdom --version failed."
    fftwf-wisdom cif3x4x5 2>&1 | grep -q "fftwf_wisdom"
    CHECK_RESULT $? 0 0 "fftwf-wisdom output failed."
    fftwf-wisdom -v cif3x4x5 2>&1 | grep -q "Planning transform"
    CHECK_RESULT $? 0 0 "Check fftwf-wisdom -v failed."
    fftwf-wisdom --verbose cif3x4x5 2>&1 | grep -q "Planning transform"
    CHECK_RESULT $? 0 0 "Check fftwf-wisdom --verbose failed."
    fftwf-wisdom -t "1e-18" -c 2>&1 | grep -q "fftwf_wisdom"
    CHECK_RESULT $? 0 0 "Check fftwf-wisdom -c failed."
    fftwf-wisdom -t "1e-18" --canonical 2>&1 | grep -q "fftwf_wisdom"
    CHECK_RESULT $? 0 0 "Check fftwf-wisdom --canonical failed."
    fftwf-wisdom -v -t "1e-18" -c 2>&1 | grep -q "TIME LIMIT"
    CHECK_RESULT $? 0 0 "Check fftwf-wisdom -t failed."
    fftwf-wisdom -v --time-limit="1e-18" --canonical 2>&1 | grep -q "TIME LIMIT"
    CHECK_RESULT $? 0 0 "Check fftwf-wisdom --time-limit=<h> failed."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"