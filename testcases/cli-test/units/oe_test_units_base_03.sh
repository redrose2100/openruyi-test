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
    spawn units --oldstar
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "\\\* 0.2\\r.*/ 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units --oldstar failed"
    expect<<EOF
    spawn units --newstar
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "\\\* 0.2\\r.*/ 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units --newstar failed"
    expect<<EOF
    spawn units -n
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "\\\* 0.2\\r.*/ 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units -n failed"
    expect<<EOF
    spawn units --nolists
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "\\\* 0.2\\r.*/ 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units --nolists failed"
    expect<<EOF
    spawn units -S
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "\\\* 0.2\\r.*/ 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units -S failed"
    expect<<EOF
    spawn units --show-factor
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "\\\* 0.2\\r.*/ 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units --show-factor failed"
    expect<<EOF
    spawn units -o %0.7g
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "7\n"}
    }
    expect -re "\\\* 0.1428571\\r.*/ 7" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units -o failed"
    expect<<EOF
    spawn units --output-format %0.7g
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "7\n"}
    }
    expect -re "\\\* 0.1428571\\r.*/ 7" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units --output-format failed"
    expect<<EOF
    spawn units -p
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "\\\* 0.2\\r.*/ 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units -p failed"
    expect<<EOF
    spawn units --product
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "\\\* 0.2\\r.*/ 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units --product failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"