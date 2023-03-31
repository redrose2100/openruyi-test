#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2023-3-31
# @License   :   Mulan PSL v2
# @Desc      :   Command aulastlog
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    useradd test1
    useradd test2
    echo test1:deepin12#$ | chpasswd
    echo test2:deepin12#$ | chpasswd
    LOG_INFO "End to prepare the test environment."
}



function run_test() {
    LOG_INFO "start to run test."
    expect <<EOF
    spawn ssh test1@localhost
    expect "*yes/no*" { send "yes\\r" }
    expect "*assword:" { send "deepin12#$\\r" }
    expect eof
EOF
    systemctl status auditd.service | grep "active (running)"
    CHECK_RESULT $? 0 0 "auditd.service is not running"
    aulastlog
    CHECK_RESULT $? 0 0 "all login log is not find"
    aulastlog -u test1 | grep test1
    CHECK_RESULT $? 0 0 "test1 login log is not find"
    aulastlog -u test2 | grep "Never logged in"
    CHECK_RESULT $? 0 0 "test2 login log is not find"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf test1
    userdel -rf test2
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
