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
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    expect<<EOF
    spawn units -q
    send "1\n5\n"
    expect -re "\\\* 0.2\\r.*/ 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units -q failed"
    expect<<EOF
    spawn units --quiet
    send "1\n5\n"
    expect -re "\\\* 0.2\\r.*/ 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units --quiet failed"
    expect<<EOF
    spawn units --silent
    send "1\n5\n"
    expect -re "\\\* 0.2\\r.*/ 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units --silent failed"
    expect<<EOF
    spawn units -s
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "\\\* 0.2\\r.*/ 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units -s failed"
    expect<<EOF
    spawn units --strict
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "\\\* 0.2\\r.*/ 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units --strict failed"
    expect<<EOF
    spawn units -v
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "1 = 0.2 \\\* 5\\r.*1 = \\\(1 / 5\\\) \\\* 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units -v failed"
    expect<<EOF
    spawn units --verbose
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "1 = 0.2 \\\* 5\\r.*1 = \\\(1 / 5\\\) \\\* 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units --verbose failed"
    expect<<EOF
    spawn units --compact
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "1 = 0.2 \\\* 5\\r.*1 = \\\(1 / 5\\\) \\\* 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units --compact failed"
    expect<<EOF
    spawn units -1
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "\\\* 0.2" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units -1 failed"
    expect<<EOF
    spawn units --one-line
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "\\\* 0.2" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units --one-line failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"