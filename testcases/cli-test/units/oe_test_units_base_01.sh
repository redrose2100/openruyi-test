#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   huangjiayi
# @Contact   :   1960887351@qq.com
# @Date      :   2022/9/23
# @License   :   Mulan PSL v2
# @Desc      :   Test "units" command
# ##################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test(){
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "units"
    touch test.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    units -h | grep "Usage: units"
    CHECK_RESULT $? 0 0 "Check units -h failed"
    units --help | grep "Usage: units"
    CHECK_RESULT $? 0 0 "Check units --help failed"
    units -c | grep "Currency exchange rates from"
    CHECK_RESULT $? 0 0 "Check units -c failed"
    units --check | grep "Currency exchange rates from"
    CHECK_RESULT $? 0 0 "Check units --check failed"
    units --check-verbose | grep "doing"
    CHECK_RESULT $? 0 0 "Check units --check-verbose failed"
    units --verbose-check | grep "doing"
    CHECK_RESULT $? 0 0 "Check units --verbose-check failed"
    expect<<EOF
    spawn units -d 8
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "\\\* 0.2\\r.*/ 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units -d failed"
    expect<<EOF
    spawn units --digits 8
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "\\\* 0.2\\r.*/ 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units --digits failed"
    expect<<EOF
    spawn units -e
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "\\\* 2.0000000e-01\\r.*/ 5.0000000e\\\+00" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units -e failed"
    expect<<EOF
    spawn units --exponential
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "\\\* 2.0000000e-01\\r.*/ 5.0000000e\\\+00" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units --exponential failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf test.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"