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
    ln -s ./common/file ./file_sl
    ln ./common/file ./file_hl
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    pax -wvPf ./tmp/test_P.tar.gz ./file_hl ./file_sl ./common/file 2>&1 | grep "pax: ustar vol 1, 3 files, 0 bytes read, 10240 bytes written."
    CHECK_RESULT $? 0 0 "Failed to run command: pax -P"
    test -f ./tmp/test_P.tar.gz
    CHECK_RESULT $? 0 0 "Failed to run command: pax -P"
    pax -wvH -f ./tmp/test_H.tar.gz ./file_hl ./file_sl ./common/file 2>&1 | grep "pax: ustar vol 1, 3 files, 0 bytes read, 10240 bytes written."
    CHECK_RESULT $? 0 0 "Failed to run command: pax -H"
    test -f ./tmp/test_H.tar.gz
    CHECK_RESULT $? 0 0 "Failed to run command: pax -H"
    pax -rwH ./file_hl ./tmp
    test -f ./tmp/file_hl
    CHECK_RESULT $? 0 0 "Failed to run command: pax -H"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf tmp *.log file_hl file_sl
    LOG_INFO "End to restore the test environment."
}

main "$@"
