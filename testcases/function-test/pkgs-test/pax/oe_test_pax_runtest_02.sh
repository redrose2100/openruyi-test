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
    pax -wf ./tmp/test_a.tar.gz common/file
    pax -w -a common/test.log -f ./tmp/test_a.tar.gz
    tar -tvf ./tmp/test_a.tar.gz 2>&1 | grep "common/test.log" 
    CHECK_RESULT $? 0 0 "Failed to run command: pax -a"
    pax -wf ./tmp/test_d.tar.gz -d common 
    tar -tvf ./tmp/test_d.tar.gz 2>&1 | grep "common/file" 
    CHECK_RESULT $? 1 0 "Failed to run command: pax -d"
    pax -wf ./tmp/test_s.tar.gz -s ':common:test/test:g' common
    tar -tvf ./tmp/test_s.tar.gz 2>&1 | grep "test/test"
    CHECK_RESULT $? 0 0 "Failed to run command: pax -s"
    pax -wf ./tmp/test_U.tar.gz -U $(ls -l common/file | awk '{print $3}') common/file
    tar -tvf ./tmp/test_U.tar.gz 2>&1 | grep "common/file"
    CHECK_RESULT $? 0 0 "Failed to run command: pax -U"
    pax -wf ./tmp/test_G.tar.gz -G $(ls -l common/file | awk '{print $4}') common/file
    tar -tvf ./tmp/test_G.tar.gz 2>&1 | grep "common/file"
    CHECK_RESULT $? 0 0 "Failed to run command: pax -G"
    pax -T 0000 -wf ./tmp/test_T.tar.gz common
    tar -tvf ./tmp/test_T.tar.gz 2>&1 | grep "file"
    CHECK_RESULT $? 0 0 "Failed to run command: pax -T"
expect <<EOF
    spawn pax -wf ./tmp/test_i.tar.gz common/file -i
    expect "Input >" 
    send "test-i\n"
    expect eof
EOF
    tar -tvf ./tmp/test_i.tar.gz 2>&1 | grep "test-i" 
    CHECK_RESULT $? 0 0 "Failed to run command: pax -i"

expect <<EOF
    spawn pax -rf test
    expect "Archive name >" 
    send ".\n"
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Failed to run command: pax -r"
    pax -rwl ./common/file ./tmp
    ls -i ./tmp/common/file 2>&1 | grep "$(ls -i ./common/file | awk '{print $1}')"
    CHECK_RESULT $? 0 0 "Failed to run command: pax -l"
    pax -wu -f ./tmp/test_u.tar.gz common/file
    test -f ./tmp/test_u.tar.gz
    CHECK_RESULT $? 0 0 "Failed to run command: pax -u"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"