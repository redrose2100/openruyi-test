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
#@Author    	:   zhangjujie2
#@Contact   	:
#@Date      	:
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test for nmon
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "nmon"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    # option +
    expect <<EOF
    spawn nmon
    send "+\r"
    expect "4secs" {
        exec touch ./interactive_+
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_+
    CHECK_RESULT $? 0 0 "Failed option: +"
    # option -
    expect <<EOF
    spawn nmon -s4
    send -- "-\r"
    expect "2secs" {
        exec touch ./interactive_-
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_-
    CHECK_RESULT $? 0 0 "Failed option: -"
    # option 0
    expect <<EOF
    spawn nmon
    send "l0\r"
    expect "%-| |" {
        exec touch ./interactive_0
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_0
    CHECK_RESULT $? 0 0 "Failed option: 0"
    # option 1
    expect <<EOF
    spawn nmon
    send "1\r"
    expect -re "mode=1.*Nice.*Prior.*Status" {
        exec touch ./interactive_1
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_1
    CHECK_RESULT $? 0 0 "Failed option: 1"
    # option 3
    expect <<EOF
    spawn nmon
    send "3\r"
    expect -re "mode=3.*CPU.*Size.*Res.*Faults" {
        exec touch ./interactive_3
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_3
    CHECK_RESULT $? 0 0 "Failed option: 3"
    # option 4
    expect <<EOF
    spawn nmon
    send "4\r"
    expect "mode=4" {
        exec touch ./interactive_4
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_4
    CHECK_RESULT $? 0 0 "Failed option: 4"
    # option 5
    expect <<EOF
    spawn sudo nmon
    expect "password" {
        send $NODE1_PASSWORD
    }
    send "5\r"
    expect "mode=5" {
        exec touch ./interactive_5
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_5
    CHECK_RESULT $? 0 0 "Failed option: 5"
    # option 6
    expect <<EOF
    spawn nmon
    send "l6\r"
    expect "60%-|+" {
        exec touch ./interactive_6
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_6
    CHECK_RESULT $? 0 0 "Failed option: 6"
    # option 7
    expect <<EOF
    spawn nmon
    send "l7\r"
    expect "70%-|+" {
        exec touch ./interactive_7
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_7
    CHECK_RESULT $? 0 0 "Failed option: 7"
    # option 8
    expect <<EOF
    spawn nmon
    send "l8\r"
    expect "80%-|+" {
        exec touch ./interactive_8
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_8
    CHECK_RESULT $? 0 0 "Failed option: 8"
    # option 9
    expect <<EOF
    spawn nmon
    send "l9\r"
    expect "90%-|+" {
        exec touch ./interactive_9
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_9
    CHECK_RESULT $? 0 0 "Failed option: 9"
    # option space
    expect <<EOF
    spawn nmon
    send " \r"
    send "q"
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Failed option: space"
    # start-up control
    export NMON=cm
    expect <<EOF
    spawn nmon
    expect -re "CPU Utilisation.*Memory and Swap" {
        exec touch ./interactive_startUpControl
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_startUpControl
    CHECK_RESULT $? 0 0 "Failed option: start-up control"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start restore the test environment."
    DNF_REMOVE "nmon"
    rm ./interactive_*
    unset NMON
    LOG_INFO "End to restore the test environment."
}

main "$@"


