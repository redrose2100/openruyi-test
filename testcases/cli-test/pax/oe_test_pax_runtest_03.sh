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
    pax -w -B 1024 -f /dev/null common/file
    CHECK_RESULT $? 0 0 "Failed to run command: pax -B"
    pax -rv -p a -f ./common/test.pax
    test -f test.log
    rm -rf test.log
    CHECK_RESULT $? 0 0 "Failed to run command: pax -p"
    cp -rf ./common/test.log test.log
    pax -rvk -f ./common/test.pax
    cat test.log 2>&1 | grep "test"
    CHECK_RESULT $? 0 0 "Failed to run command: pax -k"
    pax -rv -f ./common/test.pax -n '*.log' 2>&1 | grep "test.log"
    CHECK_RESULT $? 0 0 "Failed to run command: pax -n"
    pax -rv -f ./common/test.pax -c '*.log'
    CHECK_RESULT $? 0 0 "Failed to run command: pax -c"
    pax -f ./common/test.pax -E 0
    CHECK_RESULT $? 0 0 "Failed to run command: pax -E"
    pax -rvZ -f ./common/test.pax -c '*.log' 2>&1 | grep "Failed"
    CHECK_RESULT $? 1 0 "Failed to run command: pax -Z" 
    pax -rvZ -f ./common/test.pax -c '*.log' 2>&1 | grep "pax: ustar vol 1, 1 files, 10240 bytes read, 0 bytes written."
    CHECK_RESULT $? 0 0 "Run command successfully: pax -Z"
    pax -rvD -f ./common/test.pax -c '*.log' 2>&1 | grep "Failed"
    CHECK_RESULT $? 1 0 "Failed to run command: pax -D"
    pax -rvZ -f ./common/test.pax -c '*.log' 2>&1 | grep "pax: ustar vol 1, 1 files, 10240 bytes read, 0 bytes written."
    CHECK_RESULT $? 0 0 "Run command successfully: pax -Z"
    pax -rvY -f ./common/test.pax -c '*.log' 2>&1 | grep "Failed"
    CHECK_RESULT $? 1 0 "Failed to run command: pax -Y"
    pax -rvZ -f ./common/test.pax -c '*.log' 2>&1 | grep "pax: ustar vol 1, 1 files, 10240 bytes read, 0 bytes written."
    CHECK_RESULT $? 0 0 "Run command successfully: pax -Z"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf tmp *.log file_hl file_sl
    LOG_INFO "End to restore the test environment."
}

main "$@"
