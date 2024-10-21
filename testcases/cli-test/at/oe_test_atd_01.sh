#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2024/03/05
# @License   :   Mulan PSL v2
# @Desc      :   test at
# ############################################

source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "at"
  mkdir /home/test_at
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    test_execution atd.service
    time1=$(date -d "1 minutes" "+%H:%M")
    expect <<-EOF
set timeout 10
spawn at $time1
expect "at"
send "echo 'test at' > /home/test_at/test1.log\\r"
expect "at"
send "\\004\\r"
expect eof
EOF
    timeout=80
    while [ $timeout -gt 0 ]; do
        if test -f /home/test_at/test1.log; then
        break
        fi
        sleep 5
        timeout=$((timeout-5))
    done
    grep 'test at' /home/test_at/test1.log
    CHECK_RESULT $? 0 0 "Test1 failed"
    
    expect <<-EOF
set timeout 10
spawn batch
expect "at"
send "echo 'This is a batch job' > /home/test_at/test2.log\\r"
expect "at"
send "\\004\\r"
expect eof
EOF
    timeout=800
    while [ $timeout -gt 0 ]; do
        if test -f /home/test_at/test2.log; then
        break
        fi
        sleep 5
        timeout=$((timeout-5))
    done
    grep 'This is a batch job' /home/test_at/test2.log
    CHECK_RESULT $? 0 0 "Test2 failure"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /home/test_at
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
