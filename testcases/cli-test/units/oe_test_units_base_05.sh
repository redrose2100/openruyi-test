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
    spawn units -t
    send "1\n5\n"
    expect "0.2" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units -t failed"
    expect<<EOF
    spawn units --terse
    send "1\n5\n"
    expect "0.2" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units --terse failed"
    expect<<EOF
    spawn units -r
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "\\\* 0.2\\r.*/ 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units -r failed"
    expect<<EOF
    spawn units --round
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "\\\* 0.2\\r.*/ 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units --round failed"
    units -U | grep "/usr/share/units/definitions.units"
    CHECK_RESULT $? 0 0 "Check units -U failed"
    units --unitsfile | grep "/usr/share/units/definitions.units"
    CHECK_RESULT $? 0 0 "Check units --unitsfile failed"
    units_cur -h | grep "usage: units_cur"
    CHECK_RESULT $? 0 0 "Check units_cur -h failed"
    units_cur --help | grep "usage: units_cur"
    CHECK_RESULT $? 0 0 "Check units_cur --help failed"
    units_cur -v
    CHECK_RESULT $? 0 0 "Check units_cur -v failed"
    units_cur --verbose
    CHECK_RESULT $? 0 0 "Check units_cur --verbose failed"
    units_cur - | grep "# ISO Currency Codes"
    CHECK_RESULT $? 0 0 "Check units_cur filename failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"