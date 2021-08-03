#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   Jevons
#@Contact   	:   1557927445@qq.com
#@Date      	:   2021-05-19 09:39:43
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   logfile full operation
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test()
{
    LOG_INFO "Start to run test."
    systemctl start auditd
    CHECK_RESULT $?
    auditctl -D
    CHECK_RESULT $?
    auditctl -a always,exit -S execve -k command
    CHECK_RESULT $?
    auditctl -l |grep -e "-a always,exit -S execve -F key=command"
    CHECK_RESULT $?
    starttime=$(date +%T)
    mkdir test
    endtime=$(date +%T)
    ausearch -ts "${starttime}" -te "${endtime}" -k command |grep mkdir
    CHECK_RESULT $?
    aureport -u -i --summary 
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf test
    LOG_INFO "End to restore the test environment."
}

main "$@"
