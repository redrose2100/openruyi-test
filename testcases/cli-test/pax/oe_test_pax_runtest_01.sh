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
# @Author    :   zhoulimin
# @Contact   :   limin@isrc.iscas.ac.cn 
# @Date      :   2022-10-15
# @License   :   Mulan PSL v2
# @Desc      :   The test of pax package 
####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "pax tar"
    test -d tmp || mkdir tmp
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    pax -wv common/file 2>&1 | grep -a "common/file"
    CHECK_RESULT $? 0 0 "Failed to run command: pax -w"
    pax -wf ./tmp/test_f.tar.gz common/file
    test -f ./tmp/test_f.tar.gz
    CHECK_RESULT $? 0 0 "Failed to run command: pax -f"
    pax -wzf ./tmp/test_z.tar.gz common/file
    file ./tmp/test_z.tar.gz 2>&1 | grep "gzip"
    CHECK_RESULT $? 0 0 "Failed to run command: pax -z"
    pax -wv common/file 2>&1 | grep "ustar"
    CHECK_RESULT $? 0 0 "Failed to run command: pax -v"
    pax -wvf ./tmp/test_x.tar.gz common/file -x cpio 2>&1 | grep "cpio"
    CHECK_RESULT $? 0 0 "Failed to run command: pax -x"
    pax -wtf ./tmp/test_t.tar.gz common/file
    test -f ./tmp/test_t.tar.gz
    CHECK_RESULT $? 0 0 "Failed to run command: pax -t"
    pax -wXf ./tmp/test_X.tar.gz common
    test -f ./tmp/test_X.tar.gz
    CHECK_RESULT $? 0 0 "Failed to run command: pax -X"
    pax -wOf ./tmp/test_O.tar.gz common
    test -f ./tmp/test_O.tar.gz
    CHECK_RESULT $? 0 0 "Failed to run command: pax -O"
    pax -w0f ./tmp/test_0.tar.gz common
    test -f ./tmp/test_0.tar.gz
    CHECK_RESULT $? 0 0 "Failed to run command: pax -0"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"