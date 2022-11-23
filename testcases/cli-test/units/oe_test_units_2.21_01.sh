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
    spawn units --conformable
    expect {
        "You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "\\\* 0.2\\r.*/ 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units --conformable failed"
    expect<<EOF
    spawn units -u gauss
    expect {
        "(Gaussian) You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "\\\* 0.2\\r.*/ 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units -u failed"
    expect<<EOF
    spawn units --units gauss
    expect {
        "(Gaussian) You have:" {send "1\n";exp_continue}
        "You want:" {send "5\n"}
    }
    expect -re "\\\* 0.2\\r.*/ 5" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check units --units failed"
    units -V | grep "GNU Units version 2.21"
    CHECK_RESULT $? 0 0 "Check units -V failed"
    units --version | grep "GNU Units version 2.21"
    CHECK_RESULT $? 0 0 "Check units --version failed"
    units -I | grep "GNU Units version 2.21"
    CHECK_RESULT $? 0 0 "Check units -I failed"
    units --info | grep "GNU Units version 2.21"
    CHECK_RESULT $? 0 0 "Check units --info failed"
    units_cur -V | grep "units_cur version 5.0"
    CHECK_RESULT $? 0 0 "Check units_cur -V failed"
    units_cur --version | grep "units_cur version 5.0"
    CHECK_RESULT $? 0 0 "Check units_cur --version failed"
    units_cur -s floatrates
    CHECK_RESULT $? 0 0 "Check units_cur -s failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"