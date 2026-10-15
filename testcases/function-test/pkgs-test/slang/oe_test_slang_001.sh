#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #######################################################
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2023/04/03
# @License   :   Mulan PSL v2
# @Desc      :   Test  S-Lang function verification
# #######################################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "slang slang-slsh" 
    mkdir /tmp/test1
    mkdir /tmp/test2
    mkdir /tmp/test1/testdir
    touch /tmp/test2/testfile
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /tmp/test1
    expect <<-END
    spawn slsh
    log_file /tmp/test1/log.txt
    expect "slsh"
    send "help\\n"
    expect "slsh"
    send "!ls\\n"
    expect "slsh"
    send "!cd /tmp/test2\\n"
    expect "slsh"
    send "!ls\\n"
    expect eof
    exit
END
    grep 'help <help-topic>' /tmp/test1/log.txt
    CHECK_RESULT $? 0 0 "help failure"
    grep 'testdir' /tmp/test1/log.txt
    CHECK_RESULT $? 0 0 "Directory error"
    grep 'testfile' /tmp/test1/log.txt
    CHECK_RESULT $? 0 0 "Directory error2"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf /tmp/test1 /tmp/test2
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
